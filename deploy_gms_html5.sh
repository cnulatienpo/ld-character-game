#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <path-to-gamemaker-html5-export>" >&2
  exit 1
fi

SRC_DIR="$1"
DEST_DIR="web"

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: source directory '$SRC_DIR' does not exist." >&2
  exit 1
fi

if [ ! -f "$SRC_DIR/index.html" ]; then
  echo "Error: source directory '$SRC_DIR' does not contain index.html." >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

# Copy export contents into web/
cp -a "$SRC_DIR"/. "$DEST_DIR"/

NOJEKYLL="$DEST_DIR/.nojekyll"
if [ ! -f "$NOJEKYLL" ]; then
  touch "$NOJEKYLL"
fi

ERROR_PAGE="$DEST_DIR/404.html"
if [ ! -f "$ERROR_PAGE" ]; then
  cat > "$ERROR_PAGE" <<'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Page not found</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      body {
        font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        background: #0f1419;
        color: #f7f7f7;
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        text-align: center;
        margin: 0;
        padding: 2rem;
      }
      main {
        max-width: 28rem;
      }
      a {
        color: #4fc3f7;
      }
    </style>
    <script>
      window.addEventListener("DOMContentLoaded", function () {
        setTimeout(function () {
          window.location.replace("/");
        }, 2000);
      });
    </script>
  </head>
  <body>
    <main>
      <h1>Lost in space?</h1>
      <p>The page you requested is somewhere else. Taking you back to the start…</p>
      <p><a href="/">Return now</a></p>
    </main>
  </body>
</html>
HTML
fi

chmod +x "$0"

git add "$DEST_DIR" deploy_gms_html5.sh .github/workflows/gh-pages.yml README.md 2>/dev/null || true

if git diff --cached --quiet; then
  echo "No changes detected to commit."
else
  git commit -m "Deploy GameMaker HTML5 export"
fi

cat <<'NEXT'
Next steps:
  1. git push origin $(git rev-parse --abbrev-ref HEAD)
  2. GitHub Actions will publish to Pages.
NEXT
