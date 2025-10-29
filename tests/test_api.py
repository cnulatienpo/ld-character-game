from __future__ import annotations

import sys
from pathlib import Path

import pytest
from fastapi.testclient import TestClient

# Ensure the local package is importable when running tests without installation
ROOT = Path(__file__).resolve().parents[1]
PACKAGE_DIR = ROOT / "character_api"
if PACKAGE_DIR.exists():
    sys.path.insert(0, str(PACKAGE_DIR))

try:
    from server.loaders import LESSONS
    from server.main import app
except ModuleNotFoundError as exc:  # pragma: no cover - test environment safeguard
    pytest.skip(f"server package could not be imported: {exc}", allow_module_level=True)


@pytest.fixture(scope="module")
def client() -> TestClient:
    with TestClient(app) as test_client:
        yield test_client


def require_lessons() -> None:
    if not LESSONS:
        pytest.skip("No lessons available; ensure data/lessons/*.jsonl is present")


def test_status_ok(client: TestClient) -> None:
    response = client.get("/status")
    assert response.status_code == 200
    payload = response.json()
    assert payload.get("ok") is True
    assert "version" in payload


def test_features(client: TestClient) -> None:
    response = client.get("/features")
    assert response.status_code == 200
    payload = response.json()
    assert "features" in payload
    assert payload["features"], "Expected at least one feature flag"
    for key, value in payload["features"].items():
        assert isinstance(value, bool), f"Feature '{key}' should be a boolean"


def test_attempt_flow(client: TestClient) -> None:
    require_lessons()
    lesson_id = next(iter(LESSONS.keys()))
    response = client.post(
        "/api/attempt",
        json={
            "userId": "pytest-user",
            "itemId": lesson_id,
            "mode": "practice",
            "answer": (
                "Trade details arrive as my hero greets Lysa, promising fair trade with "
                "colorful stories shared today."
            ),
        },
    )
    assert response.status_code == 200
    payload = response.json()
    for key in {"ok", "id", "score", "passed", "level", "xpDelta"}:
        assert key in payload
    assert payload["ok"] is True
    assert payload["id"] == lesson_id


def test_progress_roundtrip(client: TestClient) -> None:
    response = client.get("/api/progress/state", params={"userId": "pytest-user"})
    assert response.status_code == 200
    payload = response.json()
    for key in ["xp", "level", "cards"]:
        assert key in payload


def test_next_and_skip(client: TestClient) -> None:
    require_lessons()
    response = client.get("/api/next", params={"userId": "pytest-user"})
    if response.status_code == 404:
        pytest.skip("Scheduler returned no lessons to serve")
    assert response.status_code == 200
    payload = response.json()
    lesson_id = payload["id"]
    skip_response = client.post(
        "/api/skip",
        json={"userId": "pytest-user", "itemId": lesson_id, "reason": "test"},
    )
    assert skip_response.status_code == 200
    skip_payload = skip_response.json()
    assert skip_payload.get("ok") is True
    assert skip_payload.get("skipped") == lesson_id
    if skip_payload.get("next") is not None:
        assert "id" in skip_payload["next"]


def test_telemetry_accepts(client: TestClient) -> None:
    response = client.post(
        "/api/telemetry",
        json={
            "userId": "pytest-user",
            "event": "session_start",
            "version": "0.1.0",
            "timestamp": 1_700_000_000,
            "meta": {"platform": "html5"},
        },
    )
    assert response.status_code == 200
    payload = response.json()
    assert payload.get("ok") is True
