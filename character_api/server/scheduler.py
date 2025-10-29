"""Scheduler for determining the next lesson for a user."""
from __future__ import annotations

from typing import Optional

from .loaders import LESSONS
from .storage import STORAGE


def next_for_user(user_id: str) -> Optional[str]:
    """Return the next lesson identifier for ``user_id``.

    Policy: return the first lesson the user has not passed. If all are passed,
    return the first lesson id. ``None`` is returned when no lessons are loaded.
    """

    if not LESSONS:
        return None

    progress = STORAGE.get_progress(user_id)
    lesson_ids = sorted(LESSONS.keys())

    for lesson_id in lesson_ids:
        card = progress.cards.get(lesson_id)
        if not card or not card.passed:
            return lesson_id

    return lesson_ids[0]
