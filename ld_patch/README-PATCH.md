# LD Character Game Patch Bundle

This bundle restores the dataset scaffolding, quiz seeds, lightweight engine stubs, and UI shells for local play.

## Apply

```bash
zip -r ld_patch.zip ld_patch/
unzip ld_patch.zip -d .
bash scripts/audit_and_cleanup.sh
```

## After applying

```bash
git add .
git commit -m "Restore dataset, quizzes, UI kit, engine, docs; cleanup"
git push origin main
```

## Notes
- Dataset now indexes seeders, quizzes, aliases, and sources in a normalized structure.
- Engine stubs grade locally with no network calls; UI components are minimal and tailwind-friendly.
- Scripts provide an audit and cleanup checklist so the repo stays tidy.
