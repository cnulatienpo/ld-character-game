"""Telemetry storage utilities for logging anonymous gameplay events."""
from __future__ import annotations

import json
import time
from pathlib import Path
from typing import Any, Dict

from pydantic import BaseModel, Field

# Default path for telemetry storage
DATA_DIR = Path(__file__).resolve().parents[2] / "data" / "store"
DEFAULT_TELEMETRY_PATH = DATA_DIR / "telemetry.jsonl"


class TelemetryEvent(BaseModel):
    """Representation of an anonymous telemetry event sent from the client."""

    user_id: str = Field(..., alias="userId", description="Anonymous user/session identifier")
    event: str = Field(..., description="Name of the event (session_start, attempt, session_end, etc.)")
    version: str | None = Field(
        None, description="Version of the client emitting the telemetry"
    )
    timestamp: int | None = Field(
        None, description="Unix timestamp (seconds) when the event occurred"
    )
    meta: Dict[str, Any] = Field(
        default_factory=dict,
        description="Additional metadata for the event (device, score, etc.)",
    )

    class Config:
        allow_population_by_field_name = True
        extra = "allow"


def _prepare_event_payload(event: TelemetryEvent) -> Dict[str, Any]:
    """Convert an event to a serialisable payload, filling defaults where needed."""

    payload = event.dict(by_alias=True)
    if payload.get("timestamp") is None:
        payload["timestamp"] = int(time.time())
    payload.setdefault("meta", {})
    return payload


def save(event: TelemetryEvent, path: Path | None = None) -> Path:
    """Persist a telemetry event as a JSON line.

    Parameters
    ----------
    event:
        The telemetry event to persist.
    path:
        Optional override for the path to the telemetry log file.

    Returns
    -------
    Path
        The filesystem path that received the event.
    """

    target = path or DEFAULT_TELEMETRY_PATH
    target.parent.mkdir(parents=True, exist_ok=True)

    payload = _prepare_event_payload(event)

    with target.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(payload, ensure_ascii=False))
        handle.write("\n")

    return target


__all__ = ["TelemetryEvent", "save", "DEFAULT_TELEMETRY_PATH"]
