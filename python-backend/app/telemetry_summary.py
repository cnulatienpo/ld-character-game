"""Utility script to roll up telemetry events into daily summaries."""
from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path
from statistics import mean
from typing import Iterable, Iterator, List, MutableMapping

from .telemetry import DEFAULT_TELEMETRY_PATH


def _iter_events(path: Path) -> Iterator[MutableMapping[str, object]]:
    if not path.exists():
        return
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue


def summarise_events(events: Iterable[MutableMapping[str, object]]):
    event_counts: Counter[str] = Counter()
    unique_users = set()
    attempt_scores: List[float] = []

    for event in events:
        event_type = str(event.get("event", "unknown"))
        event_counts[event_type] += 1

        user_id = event.get("userId") or event.get("user_id")
        if isinstance(user_id, str) and user_id:
            unique_users.add(user_id)

        if event_type == "attempt":
            meta = event.get("meta") or {}
            score = None
            if isinstance(meta, dict):
                score = meta.get("score")
            if isinstance(score, (int, float)):
                attempt_scores.append(float(score))

    summary = {
        "total_events": sum(event_counts.values()),
        "unique_users": len(unique_users),
        "events_by_type": dict(event_counts),
    }

    if attempt_scores:
        summary["attempts"] = {
            "count": event_counts.get("attempt", 0),
            "average_score": round(mean(attempt_scores), 3),
        }

    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--path",
        type=str,
        default=str(DEFAULT_TELEMETRY_PATH),
        help="Path to a telemetry JSONL file (defaults to repository telemetry store)",
    )
    args = parser.parse_args(argv)

    path = Path(args.path)

    summary = summarise_events(_iter_events(path))
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":  # pragma: no cover - script entry point
    raise SystemExit(main())
