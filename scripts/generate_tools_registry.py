#!/usr/bin/env python3
import json
import re
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple

ROOT = Path(__file__).resolve().parents[1]
PATTERNS = [
    "**/*seeder*.*",
    "**/*seeders*.*",
    "**/*topics*.*",
    "**/*metrics*.*",
    "**/*tools*.*",
    "**/character*.*",
    "**/sigil*.*",
    "**/ld_character/*",
]
SUPPORTED_EXTS = {".json", ".jsonl"}


def slugify(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    value = value.strip("-")
    return value or "unnamed"


def load_candidates() -> List[Path]:
    files = set()
    for pattern in PATTERNS:
        for path in ROOT.glob(pattern):
            if path.is_file() and path.suffix.lower() in SUPPORTED_EXTS:
                files.add(path)
    return sorted(files)


def read_json(path: Path) -> Any:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = path.read_text(encoding="utf-8", errors="ignore")
    if path.suffix.lower() == ".jsonl":
        entries: List[Any] = []
        for line in text.splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            try:
                entries.append(json.loads(line))
            except json.JSONDecodeError:
                continue
        return entries
    return json.loads(text)


@dataclass
class Metric:
    id: str
    name: str
    kind: str = "gate"
    source: str = "progress"
    threshold: Any = field(default_factory=lambda: {"min": 1})
    levels: Optional[List[Dict[str, Any]]] = None
    notes: Optional[str] = None


@dataclass
class Tool:
    id: str
    name: str
    side: str = "both"
    icon: Optional[str] = None
    weight: Optional[float] = 1.0
    unlocks: List[Tuple[str, str, Any]] = field(default_factory=list)  # (topic_id, metric_id, threshold)
    notes: Optional[str] = None


@dataclass
class Topic:
    id: str
    name: str
    tags: List[str] = field(default_factory=list)
    metrics: Dict[str, Metric] = field(default_factory=dict)


def detect_topic_name(file_path: Path, entries: Iterable[Dict[str, Any]]) -> Tuple[str, List[str]]:
    concepts = []
    for entry in entries:
        concept = entry.get("concept")
        if concept:
            concepts.append(str(concept).strip())
    if concepts:
        counts: Dict[str, int] = {}
        for concept in concepts:
            counts[concept] = counts.get(concept, 0) + 1
        topic_name = max(counts.items(), key=lambda kv: kv[1])[0]
    else:
        topic_name = file_path.stem.replace("_", " ")
    topic_name = topic_name.strip().title()
    tags = sorted({slugify(topic_name).replace("-", " "), "character"})
    return topic_name, tags


def gather_entries(raw: Any) -> List[Dict[str, Any]]:
    if isinstance(raw, list):
        return [entry for entry in raw if isinstance(entry, dict)]
    if isinstance(raw, dict):
        entries: List[Dict[str, Any]] = []
        for key in ("lessons", "tiles", "entries", "records"):
            section = raw.get(key)
            if isinstance(section, list):
                entries.extend(entry for entry in section if isinstance(entry, dict))
        if not entries:
            entries.append(raw)
        return entries
    return []


def is_tool_entry(entry: Dict[str, Any]) -> bool:
    if entry.get("type") == "toolkit":
        return True
    key = str(entry.get("key", ""))
    title = str(entry.get("title", ""))
    return any(term in key.lower() for term in ("tool", "kit")) or "tool" in title.lower()


def tool_identifier(entry: Dict[str, Any]) -> Tuple[str, str]:
    label = entry.get("title") or entry.get("key") or entry.get("id")
    name = str(label).strip() or "Unnamed Tool"
    tool_id = slugify(entry.get("key") or name)
    return tool_id, name


def metric_identifier(entry: Optional[Dict[str, Any]], fallback: str) -> Tuple[str, str]:
    if entry is None:
        name = fallback
        metric_id = slugify(fallback)
        return metric_id, name
    label = entry.get("title") or entry.get("section") or entry.get("name") or fallback
    name = str(label).strip() or fallback
    metric_id = slugify(entry.get("id") or entry.get("key") or name)
    if not metric_id:
        metric_id = slugify(fallback)
    return metric_id, name


def process_file(path: Path, warnings: List[str]) -> Tuple[Optional[Topic], List[Tool]]:
    raw = read_json(path)
    entries = gather_entries(raw)
    if not entries:
        warnings.append(f"{path}: No entries found after parsing.")
        return None, []
    topic_name, tags = detect_topic_name(path, entries)
    topic_id = slugify(topic_name)
    topic = Topic(id=topic_id, name=topic_name, tags=tags)
    entries_by_id: Dict[str, Dict[str, Any]] = {}
    for entry in entries:
        entry_id = entry.get("id") or entry.get("key")
        if entry_id:
            entries_by_id[str(entry_id)] = entry

    tools: List[Tool] = []

    for entry in entries:
        if not is_tool_entry(entry):
            continue
        tool_id, tool_name = tool_identifier(entry)
        tool = Tool(id=tool_id, name=tool_name)
        tool.icon = entry.get("icon") or entry.get("key")
        if entry.get("language", {}).get("dialect_level"):
            note = f"Dialect level {entry['language']['dialect_level']} minimum."
            tool.notes = note if not tool.notes else f"{tool.notes} {note}"
        prerequisites = entry.get("precedence", {}).get("comes_after", []) or []
        if not prerequisites:
            warnings.append(f"{path}: Tool '{tool_name}' has no explicit prerequisites; defaulting to implicit gate.")
            metric_id = f"{tool_id}-access"
            metric = topic.metrics.get(metric_id)
            if not metric:
                metric = Metric(id=metric_id, name=f"Unlock {tool_name}")
                topic.metrics[metric_id] = metric
            tool.unlocks.append((topic.id, metric.id, metric.threshold))
            tools.append(tool)
            continue
        for prereq in prerequisites:
            prereq_str = str(prereq)
            metric_entry = entries_by_id.get(prereq_str)
            metric_id, metric_name = metric_identifier(metric_entry, prereq_str.replace("_", " ").title())
            metric = topic.metrics.get(metric_id)
            if not metric:
                metric = Metric(id=metric_id, name=metric_name)
                detail_notes: List[str] = []
                if metric_entry:
                    dialect = metric_entry.get("language", {}).get("dialect_level")
                    if dialect:
                        detail_notes.append(f"Dialect level <= {dialect}")
                    requires = metric_entry.get("language", {}).get("requires")
                    if requires:
                        detail_notes.append(f"Requires terms: {', '.join(map(str, requires))}")
                    gates = metric_entry.get("gates")
                    if gates:
                        detail_notes.append(f"Gates terms: {gates}")
                else:
                    warnings.append(f"{path}: Prerequisite '{prereq_str}' for tool '{tool_name}' not found; synthesizing metric.")
                if detail_notes:
                    metric.notes = " | ".join(detail_notes)
                topic.metrics[metric_id] = metric
            tool.unlocks.append((topic.id, metric.id, metric.threshold))
        tools.append(tool)
    return topic, tools


def build_registry(topics: Dict[str, Topic], tools: Dict[str, Tool]) -> Dict[str, Any]:
    topics_payload: List[Dict[str, Any]] = []
    for topic in sorted(topics.values(), key=lambda t: t.id):
        metrics_payload: List[Dict[str, Any]] = []
        for metric in sorted(topic.metrics.values(), key=lambda m: m.id):
            metric_tools: List[Dict[str, Any]] = []
            for tool in tools.values():
                for topic_id, metric_id, threshold in tool.unlocks:
                    if topic_id == topic.id and metric_id == metric.id:
                        metric_tools.append(
                            {
                                "id": tool.id,
                                "name": tool.name,
                                "side": tool.side,
                                "weight": tool.weight,
                            }
                        )
            metrics_payload.append(
                {
                    "id": metric.id,
                    "name": metric.name,
                    "kind": metric.kind,
                    "source": metric.source,
                    "threshold": metric.threshold,
                    "levels": metric.levels,
                    "tools": metric_tools,
                    "notes": metric.notes,
                }
            )
        topics_payload.append(
            {
                "id": topic.id,
                "name": topic.name,
                "tags": topic.tags,
                "metrics": metrics_payload,
            }
        )

    tools_payload: List[Dict[str, Any]] = []
    for tool in sorted(tools.values(), key=lambda t: t.id):
        unlocks_payload = []
        for topic_id, metric_id, threshold in tool.unlocks:
            if isinstance(threshold, dict):
                payload = {"topic": topic_id, "metric": metric_id}
                payload.update(threshold)
            else:
                payload = {"topic": topic_id, "metric": metric_id, "min": threshold}
            unlocks_payload.append(payload)
        tools_payload.append(
            {
                "id": tool.id,
                "name": tool.name,
                "side": tool.side,
                "icon": tool.icon,
                "weight": tool.weight,
                "unlocks": unlocks_payload,
                "notes": tool.notes,
            }
        )

    return {
        "version": "1.0.0",
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "topics": topics_payload,
        "tools": tools_payload,
    }


def build_unlocks(tools: Dict[str, Tool]) -> List[Dict[str, Any]]:
    unlocks: List[Dict[str, Any]] = []
    for tool in sorted(tools.values(), key=lambda t: t.id):
        for topic_id, metric_id, threshold in tool.unlocks:
            payload = {
                "tool_id": tool.id,
                "topic_id": topic_id,
                "metric_id": metric_id,
                "weight": tool.weight,
            }
            if isinstance(threshold, dict):
                for key, value in threshold.items():
                    if isinstance(value, (int, float)):
                        payload[key] = value
            else:
                payload["min"] = threshold
            unlocks.append(payload)
    return unlocks


def build_metrics(topics: Dict[str, Topic]) -> List[Dict[str, Any]]:
    payload: List[Dict[str, Any]] = []
    for topic in sorted(topics.values(), key=lambda t: t.id):
        for metric in sorted(topic.metrics.values(), key=lambda m: m.id):
            entry = {
                "topic_id": topic.id,
                "metric_id": metric.id,
                "name": metric.name,
                "kind": metric.kind,
                "source": metric.source,
                "threshold": metric.threshold,
            }
            if metric.levels:
                entry["levels"] = metric.levels
            if metric.notes:
                entry["notes"] = metric.notes
            payload.append(entry)
    return payload


def main() -> int:
    candidates = load_candidates()
    warnings: List[str] = []
    topics: Dict[str, Topic] = {}
    tools: Dict[str, Tool] = {}

    for path in candidates:
        try:
            topic, file_tools = process_file(path, warnings)
        except Exception as exc:  # noqa: BLE001
            warnings.append(f"{path}: Failed to process ({exc}).")
            continue
        if not topic:
            continue
        if topic.id not in topics:
            topics[topic.id] = topic
        else:
            existing = topics[topic.id]
            existing.metrics.update(topic.metrics)
        for tool in file_tools:
            if tool.id in tools:
                tools[tool.id].unlocks.extend(tool.unlocks)
            else:
                tools[tool.id] = tool

    registry = build_registry(topics, tools)
    unlocks = build_unlocks(tools)
    metrics = build_metrics(topics)

    output_dir = ROOT / "game_thingss" / "runtime"
    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "tools.registry.json").write_text(json.dumps(registry, indent=2), encoding="utf-8")
    (output_dir / "tools.unlocks.json").write_text(json.dumps(unlocks, indent=2), encoding="utf-8")
    (output_dir / "tools.metrics.json").write_text(json.dumps(metrics, indent=2), encoding="utf-8")

    warnings_path = ROOT / "docs" / "TOOLS_DISCOVERY_WARNINGS.json"
    warnings_path.parent.mkdir(parents=True, exist_ok=True)
    warnings_path.write_text(json.dumps({"warnings": warnings}, indent=2), encoding="utf-8")
    print(f"Processed {len(candidates)} files; {len(topics)} topics; {len(tools)} tools.")
    print(f"Warnings captured: {len(warnings)} (see {warnings_path})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
