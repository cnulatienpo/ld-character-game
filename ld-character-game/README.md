# LD Character Game – Vertical Slice

This repo holds code + data used by the GameMaker Studio 2 vertical slice of the **Literary Deviousness – Character** game.

## What’s here
- `/data/character_master_min.jsonl` – small card set your GML loader reads (add this file to **Included Files** in GMS2).
- `/game/scripts` & `/game/objects` – GML source you’ll paste into your GMS2 project.
- `/tools/validate_jsonl.py` – JSONL sanity checker.

## Quick start
1. In GameMaker Studio 2, open your project.
2. Add `data/character_master_min.jsonl` to **Included Files**.
3. Create scripts/objects and paste code from `/game/**` as needed.
4. Run the room with `oGame` and use **Ctrl+Enter** to submit.

## Local tooling
- Python venv in `.venv/`
- Validate your JSONL:
  ```bash
  . .venv/bin/activate
  python tools/validate_jsonl.py data/character_master_min.jsonl

