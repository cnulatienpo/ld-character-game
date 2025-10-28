from typing import Optional, Any, List
from pydantic import BaseModel


class AttemptIn(BaseModel):
    user_id: Optional[str] = None
    item_id: Optional[str] = None
    mode: Optional[str] = None
    answer: Optional[Any] = None


class GradingHint(BaseModel):
    message: str


class AttemptOut(BaseModel):
    ok: bool = True
    score: float = 0.0
    xp_delta: int = 0
    hints: List[GradingHint] = []
    raw: Optional[Any] = None


class NextItem(BaseModel):
    id: str
    item: dict
    user_id: Optional[str] = None
