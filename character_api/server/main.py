"""FastAPI application entry point."""
from __future__ import annotations

import os
import time
from datetime import datetime
from typing import Dict

from dotenv import load_dotenv
from fastapi import FastAPI, Query, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse

from .badges import evaluate_badges, update_streak
from .features import FEATURES_PAYLOAD
from .loaders import LESSONS
from .models import (
    AttemptRequest,
    AttemptResponse,
    CardProgress,
    ErrorResponse,
    NextResponse,
    ProgressState,
    SkipRequest,
    SkipResponse,
)
from .scoring import grade_attempt
from .scheduler import next_for_user
from .storage import STORAGE
from . import telemetry

load_dotenv()

APP_VERSION = "0.1.0"


def get_app() -> FastAPI:
    app = FastAPI(title="Character Game API", default_response_class=ORJSONResponse)

    origins = os.getenv("CORS_ORIGINS", "*")
    if origins:
        origin_list = [origin.strip() for origin in origins.split(",") if origin.strip()]
        if "*" in origin_list:
            allow_origins = ["*"]
        else:
            allow_origins = origin_list
    else:
        allow_origins = ["*"]

    app.add_middleware(
        CORSMiddleware,
        allow_origins=allow_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    return app


app = get_app()


def error_response(message: str, status_code: int = status.HTTP_400_BAD_REQUEST) -> ORJSONResponse:
    return ORJSONResponse(
        status_code=status_code,
        content=ErrorResponse(error=message).dict(),
    )


@app.get("/status")
def get_status() -> Dict[str, object]:
    """Return server status information."""

    return {
        "ok": True,
        "version": APP_VERSION,
        "now_iso": datetime.utcnow().isoformat() + "Z",
    }


@app.post("/api/telemetry", response_class=ORJSONResponse)
def post_telemetry(ev: telemetry.TelemetryEvent) -> Dict[str, object]:
    telemetry.append_event(ev)
    return {"ok": True}


@app.get("/api/telemetry/summary", response_class=ORJSONResponse)
def telemetry_summary(day: str | None = None) -> Dict[str, object]:
    day_value = day or datetime.utcnow().strftime("%Y-%m-%d")
    return {"ok": True, "day": day_value, "summary": telemetry.rollup_day(day_value)}


@app.get("/features")
def get_features() -> Dict[str, Dict[str, bool]]:
    """Return feature flag information."""

    return FEATURES_PAYLOAD


@app.post("/api/attempt", response_model=AttemptResponse)
def post_attempt(payload: AttemptRequest) -> ORJSONResponse:
    lesson = LESSONS.get(payload.itemId)
    if not lesson:
        return error_response("Lesson not found", status.HTTP_404_NOT_FOUND)

    score, passed, notes, _ = grade_attempt(payload.answer, lesson)
    xp_delta = int(round(10 * score))

    progress = STORAGE.get_progress(payload.userId)
    progress.attempt_count += 1

    previous_card = progress.cards.get(payload.itemId)
    card_attempts = previous_card.attempts + 1 if previous_card else 1

    streak = update_streak(progress.streak, passed)

    progress.xp += xp_delta
    progress.level = progress.xp // 100 + 1
    progress.streak = streak

    timestamp = int(time.time())
    progress.cards[payload.itemId] = CardProgress(
        passed=passed or (previous_card.passed if previous_card else False),
        score=score,
        attempts=card_attempts,
        ts=timestamp,
    )

    newly_awarded = evaluate_badges(progress, passed, lesson, progress.attempt_count, streak)
    if newly_awarded:
        badges_set = list(dict.fromkeys(progress.badges + newly_awarded))
        progress.badges = badges_set

    STORAGE.append_attempt(
        {
            "userId": payload.userId,
            "itemId": payload.itemId,
            "mode": payload.mode,
            "answer": payload.answer,
            "score": score,
            "passed": passed,
            "xpDelta": xp_delta,
        }
    )

    STORAGE.save_progress(payload.userId, progress)

    response = AttemptResponse(
        ok=True,
        id=payload.itemId,
        score=score,
        passed=passed,
        notes=notes,
        xpDelta=xp_delta,
        level=progress.level,
        badgesAwarded=newly_awarded,
        progress=progress,
    )

    return ORJSONResponse(content=response.dict())


@app.get("/api/progress/state", response_model=ProgressState)
def get_progress_state(userId: str = Query(..., min_length=1)) -> ProgressState:
    """Return the stored progress for ``userId``."""

    return STORAGE.get_progress(userId)


@app.get("/api/next", response_model=NextResponse)
def get_next(userId: str = Query(..., min_length=1)) -> ORJSONResponse:
    lesson_id = next_for_user(userId)
    if not lesson_id:
        return error_response("No lessons configured", status.HTTP_404_NOT_FOUND)
    return ORJSONResponse(content=NextResponse(id=lesson_id).dict())


@app.post("/api/skip", response_model=SkipResponse)
def post_skip(payload: SkipRequest) -> ORJSONResponse:
    lesson = LESSONS.get(payload.itemId)
    if not lesson:
        return error_response("Lesson not found", status.HTTP_404_NOT_FOUND)

    STORAGE.append_skip(
        {
            "userId": payload.userId,
            "itemId": payload.itemId,
            "reason": payload.reason,
        }
    )

    next_id = next_for_user(payload.userId)
    response = SkipResponse(
        ok=True,
        skipped=payload.itemId,
        next=NextResponse(id=next_id) if next_id else None,
    )
    return ORJSONResponse(content=response.dict())
