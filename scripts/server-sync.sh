#!/usr/bin/env bash

set -euo pipefail

TARGET="hai@air3090"
REMOTE_CONFIG_DIR=".config"
DOTFILES_DIR="dotfiles"

echo ">>> Syncing opencode to ${TARGET}..."
ssh "$TARGET" "mkdir -p \"$REMOTE_CONFIG_DIR/opencode/skills\""
rsync -az -e ssh "$DOTFILES_DIR/opencode/opencode.jsonc" "$TARGET:$REMOTE_CONFIG_DIR/opencode/opencode.jsonc"
rsync -az --delete -e ssh "$DOTFILES_DIR/opencode/skills/" "$TARGET:$REMOTE_CONFIG_DIR/opencode/skills/"

echo ">>> Syncing tmux to ${TARGET}..."
ssh "$TARGET" "mkdir -p \"$REMOTE_CONFIG_DIR/tmux\""
rsync -az -e ssh "$DOTFILES_DIR/tmux/tmux.conf" "$TARGET:$REMOTE_CONFIG_DIR/tmux/tmux.conf"

echo ">>> Remote config sync complete."
