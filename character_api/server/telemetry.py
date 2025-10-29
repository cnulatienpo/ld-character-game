"""Telemetry event models and persistence utilities."""
from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, Literal

import orjson
try:
    from pydantic import BaseModel, Field, ConfigDict
except ImportError:  # pragma: no cover - pydantic v1 fallback
    from pydantic import BaseModel, Field
    ConfigDict = None

STORE_DIR = Path(__file__).resolve().parent.parent / "data" / "store"
TELEMETRY_FILE = STORE_DIR / "telemetry.jsonl"


class TelemetryEvent(BaseModel):
    """Representation of an anonymous telemetry event emitted by the client."""

    user_id: str = Field(..., alias="userId")
    event: Literal["session_start", "attempt", "session_end", "skip", "heartbeat"]
    version: str | None = None
    timestamp: int
    meta: Dict[str, Any] | None = None

    if ConfigDict is not None:
        model_config = ConfigDict(populate_by_name=True, extra="ignore")
    else:
        class Config:
            allow_population_by_field_name = True
            extra = "ignore"


@dataclass(slots=True)
class _RollupCounts:
    sessions: int = 0
    attempts: int = 0
    ends: int = 0
    skips: int = 0
    heartbeats: int = 0


def append_event(event: TelemetryEvent) -> None:
    """Append ``event`` to the telemetry log as a JSONL row."""

    STORE_DIR.mkdir(parents=True, exist_ok=True)
    payload = event.dict(by_alias=True, exclude_none=True)
    payload.setdefault("meta", {})

    with TELEMETRY_FILE.open("ab") as handle:
        handle.write(orjson.dumps(payload))
        handle.write(b"\n")


def _iter_events() -> Iterable[Dict[str, Any]]:
    if not TELEMETRY_FILE.exists():
        return []
    with TELEMETRY_FILE.open("rb") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                yield orjson.loads(line)
            except orjson.JSONDecodeError:
                continue


def _is_same_day(timestamp: Any, day_iso: str) -> bool:
    if not isinstance(timestamp, (int, float)):
        return False
    try:
        event_day = datetime.fromtimestamp(int(timestamp), tz=timezone.utc).strftime("%Y-%m-%d")
    except (OverflowError, OSError, ValueError):
        return False
    return event_day == day_iso


def rollup_day(day_iso: str) -> Dict[str, Any]:
    """Aggregate telemetry metrics for a UTC day (``YYYY-MM-DD``)."""

    # Validate the input format.
    datetime.strptime(day_iso, "%Y-%m-%d")

    counts = _RollupCounts()
    unique_users = set()
    total_events = 0

    for event in _iter_events():
        if not _is_same_day(event.get("timestamp"), day_iso):
            continue
        total_events += 1
        event_type = str(event.get("event", "")).strip()
        user_id = event.get("userId") or event.get("user_id")
        if isinstance(user_id, str) and user_id:
            unique_users.add(user_id)

        if event_type == "session_start":
            counts.sessions += 1
        elif event_type == "attempt":
            counts.attempts += 1
        elif event_type == "session_end":
            counts.ends += 1
        elif event_type == "skip":
            counts.skips += 1
        elif event_type == "heartbeat":
            counts.heartbeats += 1

    avg_attempts = 0.0
    if counts.sessions > 0:
        avg_attempts = counts.attempts / counts.sessions

    summary = {
        "events": total_events,
        "sessions": counts.sessions,
        "attempts": counts.attempts,
        "ends": counts.ends,
        "skips": counts.skips,
        "heartbeats": counts.heartbeats,
        "uniqueUsers": len(unique_users),
        "avgAttemptsPerSession": round(avg_attempts, 2),
    }
    return summary


__all__ = ["TelemetryEvent", "append_event", "rollup_day", "TELEMETRY_FILE"]
