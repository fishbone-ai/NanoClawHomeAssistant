#!/usr/bin/env bash
# Note: no `set -e` -- we want the terminal to always come up, even if install fails.

export IS_SANDBOX=1
# Make it stick for any nested shells / tools that read profile.d too.
mkdir -p /etc/profile.d
echo 'export IS_SANDBOX=1' > /etc/profile.d/nanoclaw-sandbox.sh

# Persist Claude Code state (login, conversation history, config) across add-on
# updates. /data is the add-on's private persistent dir, always mounted.
mkdir -p /data/claude-home /data/claude-config
if [ ! -L /root/.claude ]; then
  [ -d /root/.claude ] && cp -a /root/.claude/. /data/claude-home/ 2>/dev/null
  rm -rf /root/.claude
  ln -s /data/claude-home /root/.claude
fi
mkdir -p /root/.config
if [ ! -L /root/.config/claude ]; then
  [ -d /root/.config/claude ] && cp -a /root/.config/claude/. /data/claude-config/ 2>/dev/null
  rm -rf /root/.config/claude
  ln -s /data/claude-config /root/.config/claude
fi

REPO=$(jq -r '.github_repo' /data/options.json)

if [ -z "$REPO" ] || [ "$REPO" = "null" ]; then
  echo "WARNING: github_repo not set. Configure it in the add-on Configuration tab."
else
  cd /share
  if [ ! -d nanoclaw/.git ]; then
    # Never echo $REPO -- it contains the PAT.
    REPO_SAFE=$(echo "$REPO" | sed -E 's#(https?://)[^@]+@#\1***@#')
    echo "Cloning $REPO_SAFE into /share/nanoclaw"
    git clone "$REPO" nanoclaw || echo "WARNING: clone failed -- use the terminal to fix."
  fi

  if [ -d /share/nanoclaw ]; then
    cd /share/nanoclaw
    if [ ! -d node_modules ]; then
      echo "Running npm ci (first time, compiles native modules -- can take a few minutes on a Pi)"
      npm ci || echo "WARNING: npm ci failed -- drop into the terminal to debug."
    fi

    if [ -f /share/nanoclaw/.setup-complete ]; then
      echo "Setup marker found -- starting NanoClaw in the background."
      npm start > /share/nanoclaw/nanoclaw.log 2>&1 &
    else
      echo "First run: open the NanoClaw tab in the sidebar, run 'claude' to do /setup,"
      echo "then 'touch /share/nanoclaw/.setup-complete' and restart the add-on."
    fi
  fi
fi

echo "Starting web terminal on ingress port 7681..."
exec ttyd -p 7681 -W bash
