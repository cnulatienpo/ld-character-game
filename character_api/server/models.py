"""Pydantic models for the Character Game API."""
from __future__ import annotations

from datetime import datetime
from typing import Dict, List, Optional

from pydantic import BaseModel, Field, validator


class GateRules(BaseModel):
    """Validation rules that each lesson card uses during scoring."""

    min_words: int = Field(0, ge=0)
    must_include_any: List[str] = Field(default_factory=list)
    forbid_all_caps_ratio_over: float = Field(1.0, ge=0.0, le=1.0)


class Lesson(BaseModel):
    """Lesson definition loaded from JSONL."""

    id: str
    title: str
    prompt: str
    npc: Optional[str] = None
    tags: List[str] = Field(default_factory=list)
    gate_rules: GateRules = Field(default_factory=GateRules)
    difficulty: Optional[str] = None


class CardProgress(BaseModel):
    """Progress information about a single lesson for a user."""

    passed: bool
    score: float
    attempts: int
    ts: int


class ProgressState(BaseModel):
    """Aggregated progress information for a user."""

    xp: int = 0
    level: int = 1
    badges: List[str] = Field(default_factory=list)
    attempt_count: int = 0
    streak: int = 0
    cards: Dict[str, CardProgress] = Field(default_factory=dict)

    @validator("level", pre=True, always=True)
    def ensure_min_level(cls, v: int) -> int:
        return max(1, int(v or 1))


class AttemptRequest(BaseModel):
    """Request payload for submitting an attempt."""

    userId: str
    itemId: str
    mode: str
    answer: str


class AttemptResponse(BaseModel):
    """Response payload for a graded attempt."""

    ok: bool
    id: str
    score: float
    passed: bool
    notes: str
    xpDelta: int
    level: int
    badgesAwarded: List[str]
    progress: ProgressState


class ProgressResponse(BaseModel):
    """Response payload containing only progress information."""

    progress: ProgressState


class NextResponse(BaseModel):
    """Response containing the next lesson identifier."""

    id: str


class SkipRequest(BaseModel):
    """Request payload for skipping a card."""

    userId: str
    itemId: str
    reason: Optional[str] = None


class SkipResponse(BaseModel):
    """Response payload for skip operations."""

    ok: bool
    skipped: str
    next: Optional[NextResponse] = None


class ErrorResponse(BaseModel):
    """Generic error response."""

    ok: bool = False
    error: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)
