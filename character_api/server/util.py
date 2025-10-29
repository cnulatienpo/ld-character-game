"""Utility helpers used across the Character Game backend."""
from __future__ import annotations

import re
from typing import Iterable

WORD_RE = re.compile(r"\b\w+\b", re.UNICODE)
UPPER_RE = re.compile(r"[A-Z]")
LETTER_RE = re.compile(r"[A-Za-z]")


def word_count(text: str) -> int:
    """Return the number of word-like tokens in ``text``."""

    if not text:
        return 0
    return len(WORD_RE.findall(text))


def uppercase_ratio(text: str) -> float:
    """Calculate the ratio of uppercase letters to all alphabetic letters."""

    if not text:
        return 0.0
    letters = LETTER_RE.findall(text)
    if not letters:
        return 0.0
    uppers = UPPER_RE.findall(text)
    return len(uppers) / len(letters)


def contains_any_token(text: str, tokens: Iterable[str]) -> bool:
    """Return True when any token in ``tokens`` appears as a whole word."""

    if not text:
        return False
    lowered = text.lower()
    for token in tokens:
        if not token:
            continue
        pattern = rf"\b{re.escape(token.lower())}\b"
        if re.search(pattern, lowered):
            return True
    return False
