#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Installing dependencies..."
npm install --silent

echo "Building TypeScript..."
npm run build

echo "Running SAY-only sample..."
node dist/index.js \
  --seeder data/seeder.sample.json \
  --concept Decision \
  --behavior say \
  --dialect 1 \
  --text "\"I want out,\" I tell her before anyone else hears." \
  --target low \
  --unlocked test/sample_player.json

echo "Running SHOW + pressure sample..."
node dist/index.js \
  --seeder data/seeder.sample.json \
  --concept Conflict \
  --behavior show \
  --dialect 2 \
  --text "I pace the locker row, sweat slicking my grip on the busted phone because if I miss this call I get fired." \
  --target medium \
  --unlocked test/sample_player.json

echo "Running full chain sample..."
node dist/index.js \
  --seeder data/seeder.sample.json \
  --concept Decision \
  --behavior hide \
  --dialect 3 \
  --text "Maybe it is fine, I laugh, but the room goes quiet so I pocket the cracked badge and head for the door, which means they will have to follow." \
  --target high \
  --unlocked test/sample_player.json
