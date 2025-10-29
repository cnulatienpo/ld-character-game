"""Badge evaluation helpers."""
from __future__ import annotations

from typing import List

from .models import Lesson, ProgressState

FIRST_WRITE = "FIRST_WRITE"
CONSISTENT_3 = "CONSISTENT_3"
DETAIL_DEVIL = "DETAIL_DEVIL"
MARATHON_5 = "MARATHON_5"


def update_streak(current: int, passed: bool) -> int:
    """Return the new streak value after an attempt."""

    return current + 1 if passed else 0


def _already_has(progress: ProgressState, badge: str) -> bool:
    return badge in progress.badges


def evaluate_badges(
    progress: ProgressState,
    passed: bool,
    lesson: Lesson,
    attempt_count: int,
    streak: int,
) -> List[str]:
    """Return newly earned badges based on the latest attempt."""

    newly_awarded: List[str] = []

    if passed and not _already_has(progress, FIRST_WRITE):
        newly_awarded.append(FIRST_WRITE)

    if streak >= 3 and not _already_has(progress, CONSISTENT_3):
        newly_awarded.append(CONSISTENT_3)

    if (
        passed
        and any(token.lower() == "detail" for token in lesson.gate_rules.must_include_any)
        and not _already_has(progress, DETAIL_DEVIL)
    ):
        newly_awarded.append(DETAIL_DEVIL)

    if attempt_count >= 5 and not _already_has(progress, MARATHON_5):
        newly_awarded.append(MARATHON_5)

    return newly_awarded
