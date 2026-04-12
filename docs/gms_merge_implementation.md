# GMS Merge Implementation Tracker

Status: In progress (conservative cleanup)

## Completed

- [x] Deleted orphan file `GameIntro.jsx`.
- [x] Chose conservative cleanup policy (no medium-confidence deletions yet).
- [x] Confirmed Python dependency install path is working.
- [x] Added native grader self-test script (`scr_character_grader_native_selftest`).
- [x] Added one-click debug hotkey (`F9`) in feedback panel to run self-test and show summary.

## Keep (do not delete)

- `Objects/`
- `Rooms/`
- `Scripts/`
- `Objects/obj_bootstrap_Create.gml`
- `Objects/obj_gate_Create.gml`
- `Objects/obj_lesson_controller_Create.gml`
- `Scripts/scr_gate_next.gml`
- `Scripts/scr_json_read.gml`
- `Scripts/scr_jsonl_read.gml`
- `character_api/server/main.py`
- `character_api/server/models.py`
- `character_api/server/loaders.py`
- `character_api/server/storage.py`
- `character_api/server/scoring.py`
- `character_api/server/scheduler.py`
- `character_api/server/badges.py`
- `character_api/server/features.py`
- `character_api/server/security.py`

## Overwrite (content layer only)

Replace content in these paths when your new lesson/activity data is ready:

- `dataset/chain_reaction.jsonl`
- `dataset/match_items.json`
- `dataset/museum_rounds.json`
- `dataset/orchestra_rounds.json`
- `dataset/restoration_rounds.json`
- `dataset/soundlab_rounds.json`
- `dataset/symmetry_rounds.json`
- `dataset/word_garden_rounds.json`
- `dataset/quizzes/`
- `dataset/examples_by_seed.json`
- `dataset/index.json`
- `character_api/data/lessons/`

## Review Later (defer)

- `src/`
- `ld_patch/`
- `web/`
- `character-grader/src/`
- `character-grader/dist/`

## Next implementation steps

1. Add a small bridge layer from root GML flow to API helper patterns from:
   - `character-grader/gms/scripts/scr_api.gml`
   - `character-grader/gms/scripts/scr_http.gml`
   - `character-grader/gms/scripts/scr_net_config.gml`
2. Wire one safe endpoint first (`/status`) and validate in-game.
3. Then wire `next` and `attempt` calls with rollback-safe changes.
4. Run in-game smoke pass after each integration chunk.
