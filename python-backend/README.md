# Python Backend (FastAPI) scaffold

This folder contains a minimal FastAPI scaffold to port parts of the existing Express server.

How to run (locally):

1. Create and activate a virtualenv:

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

2. Run the server:

```bash
uvicorn app.main:app --reload --port 8000
```

This scaffold includes a very small in-memory persistence helper and a simple `/api/attempt` endpoint for testing.
