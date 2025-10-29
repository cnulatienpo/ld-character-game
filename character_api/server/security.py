"""Security helpers for the FastAPI application."""
from __future__ import annotations

import os
from typing import Iterable, List

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response

DEFAULT_PRODUCTION_ORIGIN = "https://<your-gh-username>.github.io"


def _parse_origins(value: str | None) -> List[str]:
    if not value:
        return []
    return [origin.strip() for origin in value.split(",") if origin.strip()]


def apply_cors(app: FastAPI) -> None:
    """Configure CORS middleware based on environment settings."""

    env = os.getenv("ENV", "development").lower()
    allowed_origins_env = os.getenv("ALLOWED_ORIGINS")
    origins = _parse_origins(allowed_origins_env)

    if env == "production":
        if not origins:
            origins = [DEFAULT_PRODUCTION_ORIGIN]
    else:
        origins = ["*"] if not origins else origins

    allow_all = "*" in origins
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"] if allow_all else origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )


class _SecurityHeadersMiddleware(BaseHTTPMiddleware):
    """Middleware that injects a standard set of security headers."""

    def __init__(self, app: FastAPI) -> None:
        super().__init__(app)
        self._headers: Iterable[tuple[str, str]] = (
            ("X-Content-Type-Options", "nosniff"),
            ("X-Frame-Options", "DENY"),
            ("Referrer-Policy", "no-referrer"),
            ("Permissions-Policy", "interest-cohort=()"),
            # Adjust the Content-Security-Policy as needed for HTML5 builds and external assets.
            (
                "Content-Security-Policy",
                "default-src 'self' 'unsafe-inline' https: data:",
            ),
        )

    async def dispatch(self, request: Request, call_next):  # type: ignore[override]
        response: Response = await call_next(request)
        for header, value in self._headers:
            response.headers.setdefault(header, value)
        return response


def apply_security_headers(app: FastAPI) -> None:
    """Attach middleware that injects opinionated security headers."""

    app.add_middleware(_SecurityHeadersMiddleware)

