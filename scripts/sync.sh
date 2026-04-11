#!/usr/bin/env bash

# Define Paths
DOTFILES_DIR="dotfiles"
CONFIG_DIR="$HOME/.config"
CODE_DIR="$CONFIG_DIR/Code/User"
SCRIPTS_DIR="$CONFIG_DIR/scripts"

# ---------------------------------------------------------
# 0. Custom  
# ---------------------------------------------------------
rsync -aq --delete "$DOTFILES_DIR/aerc/" "$CONFIG_DIR/aerc/" --exclude 'accounts.conf'


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
    "mako"
    "lazygit"
    "lazydocker"
    "khal"
    "btop"
    "yazi"
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
# rsync -aq "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
rsync -aq "$DOTFILES_DIR/fish/cfg.fish" "$CONFIG_DIR/fish/cfg.fish"
rsync -aq "$DOTFILES_DIR/my-app.desktop" "$HOME/.local/share/applications/my-app.desktop" 
rsync -aq "$DOTFILES_DIR/opencode/opencode.jsonc" "$CONFIG_DIR/opencode/opencode.jsonc" 
rsync -aq "$DOTFILES_DIR/.cache/quickshell/theme_mode" "$HOME/.cache/quickshell/theme_mode" 

# ---------------------------------------------------------
# 3. VS Code Settings
# ---------------------------------------------------------
echo ">>> Syncing VS Code..."
mkdir -p "$CODE_DIR"
# rsync -aq "$DOTFILES_DIR/vscode/settings.json" "$CODE_DIR/"
# rsync -aq "$DOTFILES_DIR/vscode/keybindings.json" "$CODE_DIR/"

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
