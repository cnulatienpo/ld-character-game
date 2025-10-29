"""File-based persistence layer."""
from __future__ import annotations

import json
import threading
import time
from pathlib import Path
from typing import Dict

from .models import ProgressState

STORE_DIR = Path(__file__).resolve().parent.parent / "data" / "store"
ATTEMPTS_FILE = STORE_DIR / "attempts.jsonl"
PROGRESS_FILE = STORE_DIR / "progress.json"
SKIPS_FILE = STORE_DIR / "skips.jsonl"


class Storage:
    """Simple JSON/JSONL backed storage for development use."""

    def __init__(self) -> None:
        self._lock = threading.Lock()
        STORE_DIR.mkdir(parents=True, exist_ok=True)
        for path in (ATTEMPTS_FILE, SKIPS_FILE):
            if not path.exists():
                path.touch()
        if not PROGRESS_FILE.exists():
            PROGRESS_FILE.write_text("{}", encoding="utf-8")

    # Progress -----------------------------------------------------------------
    def _load_progress_map(self) -> Dict[str, Dict]:
        with PROGRESS_FILE.open("r", encoding="utf-8") as handle:
            data = json.load(handle)
        return data

    def _write_progress_map(self, data: Dict[str, Dict]) -> None:
        temp_path = PROGRESS_FILE.with_suffix(".tmp")
        with temp_path.open("w", encoding="utf-8") as handle:
            json.dump(data, handle, ensure_ascii=False, indent=2)
        temp_path.replace(PROGRESS_FILE)

    def get_progress(self, user_id: str) -> ProgressState:
        with self._lock:
            data = self._load_progress_map()
        payload = data.get(user_id, {})
        return ProgressState.parse_obj(payload) if payload else ProgressState()

    def save_progress(self, user_id: str, state: ProgressState) -> None:
        with self._lock:
            data = self._load_progress_map()
            data[user_id] = json.loads(state.json())
            self._write_progress_map(data)

    # Append-only logs ---------------------------------------------------------
    def append_attempt(self, entry: Dict) -> None:
        entry = dict(entry)
        entry.setdefault("ts", int(time.time()))
        with self._lock:
            with ATTEMPTS_FILE.open("a", encoding="utf-8") as handle:
                handle.write(json.dumps(entry, ensure_ascii=False) + "\n")

    def append_skip(self, entry: Dict) -> None:
        entry = dict(entry)
        entry.setdefault("ts", int(time.time()))
        with self._lock:
            with SKIPS_FILE.open("a", encoding="utf-8") as handle:
                handle.write(json.dumps(entry, ensure_ascii=False) + "\n")


STORAGE = Storage()
