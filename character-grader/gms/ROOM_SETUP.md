# Room Setup Checklist — rCharacter

- Create room `rCharacter`.
- Add one instance of `oGame` at position `(0, 0)`.
- Ensure object layer depth allows GUI drawing (default works).
- Include `character_master_min.jsonl` in Included Files (use the real data file; sample JSONL provided for reference).
- Add scripts (`scr_jsonl_loader`, `scr_progress`, `scr_xp_badges`, `scr_util_preview`) to the project resource tree.
- Add objects (`oGame`, `oCardUI`, `oToast`) with their respective events wired to the provided GML files.
- Verify the existing grader scripts provide `grade_submission` (and optionally `grade_preview`).

## UI Router Upgrade
- Add the new scripts to the project: `scr_ui_theme`, `scr_ui_layout`, `scr_activity_registry`, `scr_feedback_tray`, and `scr_ui_text_input`.
- Add the new objects and wire their events:
  - `oUIRouter` (Create/Step/Draw GUI from `character-grader/gms/objects`)
  - `oUITextInput` (Create/Step/Draw GUI)
  - `oUIActivityPicker` (Create/Step/Draw GUI)
- Place an instance of `oUIRouter` in the gameplay room. It will spawn the picker/input helpers automatically.
- Ensure the router has access to the existing networking scripts (`scr_api`, `scr_http`, `scr_net_config`) and progress helpers.
- Run the room, press `Ctrl+Enter` to submit from the new editor, and confirm the feedback tray updates with results.
