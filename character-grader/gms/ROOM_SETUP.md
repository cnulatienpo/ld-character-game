# Room Setup Checklist — rCharacter

- Create room `rCharacter`.
- Add one instance of `oGame` at position `(0, 0)`.
- Ensure object layer depth allows GUI drawing (default works).
- Include `character_master_min.jsonl` in Included Files (use the real data file; sample JSONL provided for reference).
- Add scripts (`scr_jsonl_loader`, `scr_progress`, `scr_xp_badges`, `scr_util_preview`) to the project resource tree.
- Add objects (`oGame`, `oCardUI`, `oToast`) with their respective events wired to the provided GML files.
- Verify the existing grader scripts provide `grade_submission` (and optionally `grade_preview`).
