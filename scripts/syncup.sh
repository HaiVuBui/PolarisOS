#!/usr/bin/env bash

# Sync live ~/.config back into the dotfiles repo (reverse of sync.sh).

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)/dotfiles"
CONFIG_DIR="$HOME/.config"

echo ">>> Syncing up zed..."
rsync -aq "$CONFIG_DIR/zed/settings.json" "$DOTFILES_DIR/zed/"
rsync -aq "$CONFIG_DIR/zed/keymap.json"   "$DOTFILES_DIR/zed/"

echo ">>> Syncup complete!"
