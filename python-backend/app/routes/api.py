from fastapi import APIRouter, HTTPException
from typing import Any

from ..models import AttemptIn, AttemptOut
from ..db.mem import mem
from ..content.loaders import load_seeders, load_datasets

router = APIRouter()


@router.get("/attempt")
async def ping():
    return {"ok": True, "message": "attempt ping"}


@router.post("/attempt", response_model=AttemptOut)
async def grade_attempt(payload: AttemptIn):
    # Very small placeholder grader: score based on word count if 'answer' is a string
    try:
        raw = payload.dict()
        score = 0.0
        xp = 0
        hints = []
        ans = payload.answer
        if isinstance(ans, str):
            wc = len(ans.split())
            score = min(1.0, wc / 100.0)
            xp = int(score * 10)
            if wc < 10:
                hints.append({"message": "Try writing a bit more for a higher score."})
        else:
            score = 0.0
        # persist attempt
        mem.append_attempt({"user_id": payload.user_id, "item_id": payload.item_id, "answer": ans, "score": score})
        return {"ok": True, "score": score, "xp_delta": xp, "hints": hints, "raw": raw}
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@router.get("/next")
async def get_next(user_id: Any = None):
    # Basic next: return first dataset item if any
    data = load_datasets()
    if not data:
        return {"ok": False, "message": "no dataset items"}
    item = data[0]
    return {"id": item.get("id", "sample-1"), "item": item, "user_id": user_id}
