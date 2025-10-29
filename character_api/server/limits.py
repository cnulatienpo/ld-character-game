"""Optional SlowAPI rate limiting helpers."""
from __future__ import annotations

import os
from typing import Callable, Optional

from fastapi import FastAPI

ENV = os.getenv("ENV", "development").lower()

LimiterType = Optional["Limiter"]

try:  # pragma: no cover - optional dependency
    if ENV == "production":
        from slowapi import Limiter
        from slowapi.errors import RateLimitExceeded
        from slowapi.middleware import SlowAPIMiddleware
        from slowapi.util import get_remote_address
    else:  # force ImportError path in non-production to keep runtime lean
        raise ImportError
except ImportError:  # pragma: no cover - executed when slowapi missing
    Limiter = None  # type: ignore[assignment]
    RateLimitExceeded = None  # type: ignore[assignment]
    SlowAPIMiddleware = None  # type: ignore[assignment]
    get_remote_address = None  # type: ignore[assignment]

limiter: LimiterType = None


def maybe_init_limiter(app: FastAPI) -> None:
    """Attach SlowAPI middleware if the dependency is installed."""

    global limiter
    if limiter is not None or Limiter is None:
        return

    limiter = Limiter(key_func=get_remote_address, default_limits=["5/second", "100/minute"])
    app.state.limiter = limiter
    app.add_exception_handler(RateLimitExceeded, limiter._rate_limit_exceeded_handler)  # type: ignore[attr-defined]
    app.add_middleware(SlowAPIMiddleware)


def rlimited(*args, **kwargs):
    """Decorator helper for per-route shared limits.

    Usage:
        from .limits import rlimited

        @app.get("/expensive")
        @rlimited
        async def expensive_route():
            ...

    To enable rate limiting install SlowAPI: ``pip install slowapi``
    and ensure ENV=production before calling :func:`maybe_init_limiter`.
    """

    if limiter is None:
        def _passthrough(func: Callable):
            return func

        return _passthrough

    # Provide a shared global scope limit; users can override parameters via kwargs.
    shared = limiter.shared_limit("5/second", scope="global")
    return shared(*args, **kwargs)

