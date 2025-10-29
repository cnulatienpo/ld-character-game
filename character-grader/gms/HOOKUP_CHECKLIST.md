# Hookup checklist

- Add the new scripts (`scr_ui_centerstack`, `scr_tool_rails`, `scr_feedback_tray`) to the project asset browser under Scripts.
- Add the new objects (`oUIStack`, `oUITextInput`) to the project and assign the corresponding Create, Step, and Draw GUI events.
- Ensure `character_master_min.jsonl` is present in Included Files so `jsonl_read_included` loads correctly.
- Place an instance of `oUIStack` in the UI room (or create it at runtime) so the center-stack interface draws.
- Confirm the Submit/Skip/Next buttons call through to the networking helpers (watch the log/toast output).
- Scroll each tool rail to verify independent wheel handling and unlock new tools via `tool_rails_unlock` in response to progress.
- Use Ctrl+Enter to send an attempt and Ctrl+K to toggle the tray, confirming the tray populates with server responses.
