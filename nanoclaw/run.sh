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

if [ -f /share/nanoclaw/.setup-complete ]; then
  echo "Setup marker found -- starting NanoClaw in the background."
  npm start > /share/nanoclaw/nanoclaw.log 2>&1 &
else
  echo "First run: open the NanoClaw tab in the sidebar, run 'claude' to do /setup,"
  echo "then 'touch /share/nanoclaw/.setup-complete' and restart the add-on."
fi

echo "Starting web terminal on ingress port 7681..."
exec ttyd -p 7681 -W bash
