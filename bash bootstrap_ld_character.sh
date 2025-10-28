#!/usr/bin/env bash
set -euo pipefail

# ============================================
# Literary Deviousness – Character Game Env Bootstrap
# - Installs system deps (git, curl, jq, python, nvm+node LTS)
# - Creates a Python venv and installs handy libs
# - Sets up a minimal repo skeleton (optional, safe if exists)
# NOTE: Install GameMaker Studio 2 manually (GUI app).
# ============================================

# ---------- Helpers ----------
os_name="$(uname -s)"
have() { command -v "$1" >/dev/null 2>&1; }
log() { printf "\n\033[1;36m[LD]\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m[WARN]\033[0m %s\n" "$*"; }
die() { printf "\n\033[1;31m[ERR]\033[0m %s\n" "$*"; exit 1; }

# ---------- OS package installs ----------
install_macos() {
  if ! have brew; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bashrc" 2>/dev/null || true
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile" 2>/dev/null || true
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  log "Installing packages with Homebrew…"
  brew update
  brew install git curl wget jq python@3.12 ripgrep fd
}

install_debian() {
  log "Installing packages with apt…"
  sudo apt-get update -y
  sudo apt-get install -y \
    git curl wget build-essential jq python3 python3-venv python3-pip \
    ripgrep fd-find unzip ca-certificates
  # fd on Debian is `fdfind`; make a friendly alias if you want
  if have fdfind && ! have fd; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    case ":$PATH:" in
      *":$HOME/.local/bin:"*) ;;
      *) echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc" ;;
    esac
  fi
}

case "$os_name" in
  Darwin)  install_macos ;;
  Linux)   install_debian ;;
  MINGW*|MSYS*|CYGWIN*)
    warn "This looks like Windows shell. Prefer WSL for this script."
    warn "On Windows (PowerShell + Chocolatey) install: git, curl, jq, python3, ripgrep, fd, and use nvm-windows."
    ;;
  *) warn "Unknown OS: $os_name – continuing, but package steps may fail." ;;
esac

# ---------- Node via nvm (LTS) ----------
if [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm…"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# shellcheck source=/dev/null
# Try several common nvm locations so the script works in containers/Codespaces
# Respect an already-set NVM_DIR first
if [ -n "${NVM_DIR-}" ] && [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "$HOME/.nvm/nvm.sh"
elif [ -s "/usr/local/share/nvm/nvm.sh" ]; then
  export NVM_DIR="/usr/local/share/nvm"
  . "/usr/local/share/nvm/nvm.sh"
elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="/opt/homebrew/opt/nvm"
  . "/opt/homebrew/opt/nvm/nvm.sh"
else
  warn "nvm not found in common locations; attempting to install to \$HOME/.nvm"
  # attempt install (idempotent if previously installed to $HOME/.nvm)
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    . "$HOME/.nvm/nvm.sh"
  else
    die "nvm still not available after install attempt; please install nvm and re-run."
  fi
fi

log "Installing Node.js LTS with nvm…"
nvm install --lts
nvm alias default 'lts/*'
nvm use default

# ---------- Python venv + packages ----------
PY=python3
if ! have $PY; then
  die "Python3 not found after install. Please install Python 3 and re-run."
fi

log "Creating Python venv (.venv)…"
$PY -m venv .venv
# shellcheck source=/dev/null
. .venv/bin/activate

log "Installing Python tooling (orjson, jsonschema, rich, typer, pre-commit)…"
pip install -U pip
pip install orjson jsonschema rich typer pre-commit

# ---------- Repo skeleton (safe if already exists) ----------
log "Ensuring repo skeleton exists…"
mkdir -p ld-character-game/{game/scripts,game/objects,game/assets,data,tools}

# .gitignore
cat > ld-character-game/.gitignore <<'EOF'
# OS junk
.DS_Store
Thumbs.db

# Python
.venv/
__pycache__/
*.pyc

# Node
node_modules/

# GameMaker Studio / build junk (you’ll still add the .yyp project separately)
*.yyz
*.yymps
*.yyp*
*.yyp.metadata
*.yy
.yyc/
build/
*.log

# Local saves
character_progress.json
EOF

# README
cat > ld-character-game/README.md <<'EOF'
# LD Character Game – Vertical Slice

This repo holds code + data used by the GameMaker Studio 2 vertical slice of the **Literary Deviousness – Character** game.

## What’s here
- `/data/character_master_min.jsonl` – small card set your GML loader reads (add this file to **Included Files** in GMS2).
- `/game/scripts` & `/game/objects` – GML source you’ll paste into your GMS2 project.
- `/tools/validate_jsonl.py` – JSONL sanity checker.

## Quick start
1. In GameMaker Studio 2, open your project.
2. Add `data/character_master_min.jsonl` to **Included Files**.
3. Create scripts/objects and paste code from `/game/**` as needed.
4. Run the room with `oGame` and use **Ctrl+Enter** to submit.

## Local tooling
- Python venv in `.venv/`
- Validate your JSONL:
  ```bash
  . .venv/bin/activate
  python tools/validate_jsonl.py data/character_master_min.jsonl

EOF
