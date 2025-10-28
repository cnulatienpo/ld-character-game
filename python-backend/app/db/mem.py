import json
from pathlib import Path
from threading import Lock
from typing import Any, Dict

from ..config import settings


class MemStore:
    """Very small in-memory store with JSONL append persistence for attempts."""

    def __init__(self):
        self.data_dir: Path = settings.data_dir
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.attempts_file = self.data_dir / "attempts.jsonl"
        self.lock = Lock()

    def append_attempt(self, rec: Dict[str, Any]):
        line = json.dumps(rec, ensure_ascii=False)
        with self.lock:
            with open(self.attempts_file, "a", encoding="utf-8") as fh:
                fh.write(line + "\n")


mem = MemStore()
