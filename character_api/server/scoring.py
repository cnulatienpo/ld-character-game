"""Scoring utilities for the character game."""
from __future__ import annotations

from typing import List, Tuple

from .models import Lesson
from .util import contains_any_token, uppercase_ratio, word_count


class ScoreResult(Tuple[float, bool, str, List[str]]):
    """Typed tuple alias for backward compatibility."""


def grade_attempt(answer: str, lesson: Lesson) -> ScoreResult:
    """Grade an ``answer`` against the gate rules of ``lesson``.

    Returns a tuple of ``(score, passed, notes, failures)``.
    """

    rules = lesson.gate_rules
    failures: List[str] = []

    score = 1.0

    if word_count(answer) < rules.min_words:
        score -= 0.3
        failures.append("Not enough words")

    if rules.must_include_any and not contains_any_token(answer, rules.must_include_any):
        score -= 0.3
        failures.append("Missing required detail")

    if uppercase_ratio(answer) > rules.forbid_all_caps_ratio_over:
        score -= 0.3
        failures.append("Too many capital letters")

    score = max(0.0, round(score, 3))
    passed = score >= 0.6

    if failures:
        notes = ", ".join(failures)
    else:
        notes = "All gates passed"

    return score, passed, notes, failures
