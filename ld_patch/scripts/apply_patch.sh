#!/usr/bin/env bash
set -euo pipefail
PATCH_DIR="ld_patch"
ZIP_NAME="ld_patch.zip"

if [ ! -d "$PATCH_DIR" ]; then
  if [ -f "$ZIP_NAME" ]; then
    unzip -o "$ZIP_NAME" -d . >/dev/null
  else
    echo "Patch bundle not found." >&2
    exit 1
  fi
fi

echo "Copying patch contents from $PATCH_DIR/"
rsync -av --exclude 'ld_patch.zip' "$PATCH_DIR"/ ./ >/dev/null

if [ -x scripts/audit_and_cleanup.sh ]; then
  bash scripts/audit_and_cleanup.sh
else
  chmod +x scripts/audit_and_cleanup.sh
  bash scripts/audit_and_cleanup.sh
fi

echo
cat <<MSG
Next steps:
zip -r ld_patch.zip ld_patch/
unzip ld_patch.zip -d .
bash scripts/audit_and_cleanup.sh
git add .
git commit -m "Dataset+quizzes+UI kit+engine+docs"
git push origin main
MSG
