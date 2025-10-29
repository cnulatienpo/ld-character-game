"""Lesson loading utilities."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Dict

from .models import Lesson

DATA_DIR = Path(__file__).resolve().parent.parent / "data" / "lessons"


def load_lessons() -> Dict[str, Lesson]:
    """Load all lessons from JSONL files under ``data/lessons``."""

    lessons: Dict[str, Lesson] = {}
    if not DATA_DIR.exists():
        return lessons

    for path in sorted(DATA_DIR.glob("*.jsonl")):
        with path.open("r", encoding="utf-8") as handle:
            for line in handle:
                line = line.strip()
                if not line:
                    continue
                payload = json.loads(line)
                lesson = Lesson.parse_obj(payload)
                lessons[lesson.id] = lesson
    return lessons


LESSONS = load_lessons()
