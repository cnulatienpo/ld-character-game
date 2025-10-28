# Character Grader

Lightweight heuristics-based grader for character writing beats. Ships with a TypeScript core, compiled JavaScript build, CLI, test harness, and a GameMaker Studio bridge.

## Quick start

```bash
cd character-grader
npm install
npm run build
# Run a sample grade
node dist/index.js \
  --seeder data/seeder.sample.json \
  --concept Decision \
  --behavior say \
  --dialect 1 \
  --text "\"I want out,\" I tell her before anyone else hears." \
  --target low \
  --unlocked test/sample_player.json
```

The CLI prints a JSON `GradeOutput` followed by a short summary.

### NPM scripts

- `npm run build` – compile TypeScript to `dist/`
- `npm start` – run the CLI entry with whatever arguments you pass (`node dist/index.js ...`)
- `npm test` – execute `test/run_tests.sh`

## How the heuristics work

The grader uses simple token scans rather than heavy NLP libraries.

- **Behavior detection** – SAY (dialogue, declarations), SHOW (action verbs, sensory anchors, object cues), HIDE (deflection phrases and tension hedges).
- **Specificity** – counts concrete nouns (`door`, `keys`, `ring`, etc.) and bonuses numbers or proper nouns.
- **Pressure** – searches for cost/risk vocabulary such as `deadline`, `get fired`, `afraid`.
- **Follow-through** – looks for cause→effect connectors (`so`, `which means`, `then I`) followed by action shifts.
- **Field change** – detects reactions from other actors or internal stance shifts (`room goes quiet`, `I’m done`).

Each signal is binary; the raw score is a simple sum. Strength tiers derive from signal combos:

- **Tier 1 (low)** – any SAY/SHOW/HIDE signal.
- **Tier 2 (medium)** – requested behavior + `pressure` + `follow_through`.
- **Tier 3 (high)** – Tier 2 + `field_change`.

## Dialect lock vocabulary

Players receive feedback filtered to their clearance level. The `speak()` helper rewrites disallowed terms:

- Level 1 terms: `moment`, `feeling`, `choice`, `want`, `cost`, `move`
- Level 2 adds: `pattern`, `pressure`, `signal`
- Level 3 adds: `scene`, `beat`, `status`
- Level 4 adds: `archetype`, `resonance`, `mythic`

If a word is outside the player’s level, it rewrites to a simpler substitute (`pressure`→`cost`, `scene`→`moment`, `signal`→`cue`, etc.).

## Seeder data

Seeder tiles live under `data/`. Each tile describes a concept, behaviors, target strength tiers, and any precedence requirements. Add your own JSON file following `data/seeder.sample.json` and point the CLI at it with `--seeder path/to/your.json`.

## GameMaker Studio bridge

`gms/character_grader.gml` provides a drop-in script for GameMaker Studio 2. Two usage modes are documented inside the file:

1. **Dev shell mode** – writes the request to disk, calls `node dist/index.js` via `shell_execute`, and reads `out.json` back into GMS.
2. **File drop mode** – dumps a JSON payload for the Node CLI to consume manually. Useful for platforms without shell access.

Both paths return the strength tier, raw score, and filtered feedback.

## Test harness

`test/run_tests.sh` installs dependencies, builds the TypeScript project, and runs three sample grades (SAY-only, SHOW+pressure, full chain). Use `npm test` to execute the script.

## Limitations & tuning

- Heuristics are intentionally lightweight; expand the lexicons in `src/heuristics.ts` to match your show’s tone.
- The dialect lock only rewrites known vocabulary—add more terms as needed.
- The CLI expects inline `--text` strings; for longer passages, extend it to read from files or STDIN.
- Current gating logic checks precedence IDs and dialect level but does not enforce complex quest logic.

## Web preview (optional)

For quick visualization, build the project and render the generated `out.json` with a static page. A minimal HTML helper is included at `web-preview.html`.
