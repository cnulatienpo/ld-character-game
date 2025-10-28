import json
from pathlib import Path
from typing import List, Dict, Any

from ..config import settings


def load_seeders() -> List[Dict[str, Any]]:
    """Load seeder JSON files from repo-level seeder/ directory as examples."""
    out = []
    d = settings.seeder_dir
    if not d.exists():
        return out
    for p in sorted(d.glob("*.json")):
        try:
            with open(p, "r", encoding="utf-8") as fh:
                out.append(json.load(fh))
        except Exception:
            continue
    # also include jsonl files
    for p in sorted(d.glob("*.jsonl")):
        try:
            with open(p, "r", encoding="utf-8") as fh:
                for line in fh:
                    line = line.strip()
                    if not line:
                        continue
                    out.append(json.loads(line))
        except Exception:
            continue
    return out


def load_datasets() -> List[Dict[str, Any]]:
    out = []
    d = settings.dataset_dir
    if not d.exists():
        return out
    for p in sorted(d.glob("*.jsonl")):
        try:
            with open(p, "r", encoding="utf-8") as fh:
                for line in fh:
                    line = line.strip()
                    if not line:
                        continue
                    out.append(json.loads(line))
        except Exception:
            continue
    return out
