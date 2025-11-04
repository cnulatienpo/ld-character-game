#!/usr/bin/env bash
set -euo pipefail
echo "=== ld-character-game audit ==="
echo "[root]"
ls -la
echo
if [ -f "uvicorn.pid" ]; then
  echo "NOTE: uvicorn.pid found – runtime artifact. Safe to delete: rm uvicorn.pid"
fi
if [ -d "Loader + normalizer + quick graph analytics" ]; then
  echo "NOTE: Folder has spaces. Consider: git mv 'Loader + normalizer + quick graph analytics' loader_normalizer_graph"
fi
if [ -d "dataset" ]; then
  echo "[dataset]"
  ls -la dataset
  echo
  echo "If you see multiple tvtropes_* files, ensure loader points to an index (dataset/index.json) and list source files in dataset/sources.json"
else
  echo "WARNING: dataset/ not found. The patch will create it."
fi
echo "=== audit complete ==="
