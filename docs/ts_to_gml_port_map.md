# TS to GML Port Map

Goal: run grading and game flow in GameMaker without requiring Node at runtime.

## Mandatory rewrites for full GameMaker-native grading

- Source: character-grader/src/heuristics.ts
  Target: Scripts/scr_character_grader_native.gml
  Status: Ported (initial native implementation)

- Source: character-grader/src/grader.ts
  Target: Scripts/scr_character_grader_native.gml
  Status: Ported (core scoring, strength, rationale, feedback)

- Source: character-grader/src/dialect.ts
  Target: Scripts/scr_character_grader_native.gml
  Status: Ported (light rewrite rules)

- Source: character-grader/src/gating.ts
  Target: Scripts/scr_character_grader_native.gml or separate script
  Status: Ported (native next_unlocks suggestion + precedence/dialect checks)

- Source: character-grader/src/types.ts
  Target: GML struct shape conventions
  Status: Ported via returned struct fields

## Bridge behavior

- Bridge file: character-grader/gms/character_grader.gml
- Current behavior:
  1. Uses character_grade_native() if available.
  2. Falls back to Node file-drop behavior if native function is unavailable.

## Already GML and does not need TS rewrite

- Scripts/scr_api.gml
- Scripts/scr_http.gml
- Scripts/scr_net_config.gml

## Remaining high-value native parity tasks

1. Tighten follow-through detection parity with TypeScript regex behavior.
2. Add native test harness script in GML for deterministic sample cases.
3. Validate unlock behavior against your real seeder tiles and concept IDs.
4. Keep Node fallback only for tooling, not runtime dependency.
