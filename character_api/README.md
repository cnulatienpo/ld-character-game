# Character Game FastAPI Backend

This repository provides a minimal FastAPI backend that mirrors the contract used by the GameMaker client.
It stores data on disk using simple JSON/JSONL files and has no database dependencies.

## Requirements

* Python 3.10+
* pip

## Installation

```bash
python -m pip install --upgrade pip
pip install -e .
```

Alternatively install dependencies directly:

```bash
pip install fastapi uvicorn[standard] pydantic orjson python-dotenv
```

## Running the Server

```bash
uvicorn server.main:app --reload --port 8000
```

The server loads practice content from JSONL files located in `data/lessons/`.
To add more lessons, drop additional `.jsonl` files into that directory; each line should
match the lesson schema documented below.

## Endpoints

* `GET /status` – returns server status and version info.
* `GET /features` – returns the currently available feature flags.
* `POST /api/attempt` – grade a user attempt, update progress, and award badges/levels.
* `GET /api/progress/state?userId=...` – fetch the full progress snapshot for a user.
* `GET /api/next?userId=...` – retrieve the identifier of the next lesson for a user.
* `POST /api/skip` – record a skip and advance to the next lesson.

## Data Files

* `data/lessons/*.jsonl` – lesson definitions, one JSON object per line with fields:
  `id`, `title`, `prompt`, `npc`, `tags`, `gate_rules`, and `difficulty`.
* `data/store/attempts.jsonl` – append-only log of graded attempts.
* `data/store/skips.jsonl` – append-only log of skipped items.
* `data/store/progress.json` – dictionary keyed by `userId` storing progress state.

All storage files are created automatically when missing.

## Environment Configuration

Copy `.env.example` to `.env` and adjust as needed. Default values:

```
PORT=8000
CORS_ORIGINS=*
```

## Development Notes

* Responses are serialized using `ORJSONResponse` for performance and consistent output.
* Persistence uses lightweight file I/O suitable for local development and demos.
* The grading, badge, and scheduler modules are intentionally simple and can be expanded.
