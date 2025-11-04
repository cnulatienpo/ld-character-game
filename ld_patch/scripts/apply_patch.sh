#!/usr/bin/env bash
set -euo pipefail
ZIP_NAME="ld_patch.zip"
if [ ! -f "$ZIP_NAME" ]; then
  if [ -d "ld_patch" ]; then
    echo "Archive $ZIP_NAME not found; creating from ld_patch/" >&2
    zip -r "$ZIP_NAME" ld_patch/ >/dev/null
  else
    echo "Patch archive $ZIP_NAME not found and ld_patch/ missing." >&2
    exit 1
  fi
fi
unzip -o "$ZIP_NAME" -d .
chmod +x scripts/audit_and_cleanup.sh
