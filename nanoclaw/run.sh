#!/usr/bin/env bash
set -e

REPO=$(jq -r '.github_repo' /data/options.json)

if [ -z "$REPO" ] || [ "$REPO" = "null" ]; then
  echo "ERROR: github_repo not set. Configure it in the add-on Configuration tab."
  exit 1
fi

cd /share
if [ ! -d nanoclaw/.git ]; then
  echo "Cloning $REPO into /share/nanoclaw"
  git clone "$REPO" nanoclaw
fi

cd /share/nanoclaw
[ -d node_modules ] || npm ci

exec npm start
