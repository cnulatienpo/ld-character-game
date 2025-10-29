"""Structured logging utilities for the API."""
from __future__ import annotations

import json
import logging
import time
from typing import Any, Dict

from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware

_LOG_INITIALIZED = False


class JsonFormatter(logging.Formatter):
    """Logging formatter that emits structured JSON objects."""

    def format(self, record: logging.LogRecord) -> str:  # type: ignore[override]
        payload: Dict[str, Any] = {
            "timestamp": self.formatTime(record, "%Y-%m-%dT%H:%M:%S%z"),
            "level": record.levelname,
            "message": record.getMessage(),
        }

        if hasattr(record, "extra_payload") and isinstance(record.extra_payload, dict):
            payload.update(record.extra_payload)

        return json.dumps(payload, ensure_ascii=False)


def init_logging(level: int = logging.INFO) -> None:
    """Initialise root logging to emit structured JSON lines."""

    global _LOG_INITIALIZED
    if _LOG_INITIALIZED:
        return

    handler = logging.StreamHandler()
    handler.setFormatter(JsonFormatter())
    logging.basicConfig(level=level, handlers=[handler])
    _LOG_INITIALIZED = True


class RequestLoggerMiddleware(BaseHTTPMiddleware):
    """Middleware that logs request/response metadata."""

    async def dispatch(self, request: Request, call_next):  # type: ignore[override]
        start_time = time.perf_counter()
        response = await call_next(request)
        latency_ms = (time.perf_counter() - start_time) * 1000

        client_host = request.client.host if request.client else None
        user_id = request.headers.get("x-user-id")

        logging.getLogger("uvicorn.access").info(
            "request",
            extra={
                "extra_payload": {
                    "path": request.url.path,
                    "method": request.method,
                    "status": response.status_code,
                    "latency_ms": round(latency_ms, 2),
                    "client_ip": client_host,
                    "user_id": user_id,
                }
            },
        )
        return response


# Usage example:
# from .logging import init_logging, RequestLoggerMiddleware
# init_logging()
# app.add_middleware(RequestLoggerMiddleware)
