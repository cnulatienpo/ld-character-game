"""CLI helper to inspect telemetry aggregates for a given day."""
from __future__ import annotations

import argparse
import json
from datetime import datetime
from typing import Any, Dict

from . import telemetry


def _format_table(day: str, summary: Dict[str, Any]) -> str:
    labels = [
        ("Sessions", summary.get("sessions", 0)),
        ("Attempts", summary.get("attempts", 0)),
        ("Session ends", summary.get("ends", 0)),
        ("Skips", summary.get("skips", 0)),
        ("Unique users", summary.get("uniqueUsers", 0)),
        (
            "Avg attempts/session",
            f"{summary.get('avgAttemptsPerSession', 0.0):.2f}",
        ),
    ]
    col_width = max(len(label) for label, _ in labels)
    lines = [f"Telemetry summary for {day}", "=" * (col_width + 18)]
    for label, value in labels:
        lines.append(f"{label:<{col_width}} : {value}")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "day",
        nargs="?",
        help="UTC day in YYYY-MM-DD format (defaults to today)",
    )
    args = parser.parse_args(argv)

    day = args.day or datetime.utcnow().strftime("%Y-%m-%d")
    summary = telemetry.rollup_day(day)

    print(_format_table(day, summary))
    print()
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":  # pragma: no cover - script entry point
    raise SystemExit(main())
