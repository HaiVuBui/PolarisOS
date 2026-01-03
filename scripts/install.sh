#!/usr/bin/env bash

# Define Paths
DOTFILES_DIR="dotfiles"
CONFIG_DIR="$HOME/.config"
CODE_DIR="$CONFIG_DIR/Code/User"
SCRIPTS_DIR="$CONFIG_DIR/scripts"

# ---------------------------------------------------------
# 1. Standard Config Folders
# ---------------------------------------------------------
APPS=(
    "hypr"
    "niri"
    "nvim"
    "kitty"
    "tmux"
    "waybar"
    "fastfetch"
    "rofi"
    "htop"
    "rmpc"
)

echo ">>> Syncing Config Apps..."
for app in "${APPS[@]}"; do
    mkdir -p "$CONFIG_DIR/$app"
    # Note: '-a' keeps archive mode. '-q' adds quiet mode.
    rsync -aq --delete "$DOTFILES_DIR/$app/" "$CONFIG_DIR/$app/"
done

# ---------------------------------------------------------
# 2. Individual Files
# ---------------------------------------------------------
echo ">>> Syncing Individual Dotfiles..."
rsync -aq "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
rsync -aq "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# ---------------------------------------------------------
# 3. VS Code Settings
# ---------------------------------------------------------
echo ">>> Syncing VS Code..."
mkdir -p "$CODE_DIR"
rsync -aq "$DOTFILES_DIR/settings.json" "$CODE_DIR/"
rsync -aq "$DOTFILES_DIR/keybindings.json" "$CODE_DIR/"

# ---------------------------------------------------------
# 4. Scripts
# ---------------------------------------------------------
echo ">>> Syncing Scripts..."
mkdir -p "$SCRIPTS_DIR"
rsync -aq --delete "scripts/" "$SCRIPTS_DIR/"

# ---------------------------------------------------------
# 5. Wallpapers
# ---------------------------------------------------------
echo ">>> Syncing Wallpapers..."
mkdir -p "$HOME/Wallpapers"
rsync -aq --delete "wallpapers/Selected/" "$HOME/Wallpapers/"

echo ">>> Dotfiles installation complete!"
