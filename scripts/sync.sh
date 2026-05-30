#!/usr/bin/env bash

# Define Paths
DOTFILES_DIR="dotfiles"
CONFIG_DIR="$HOME/.config"
CODE_DIR="$CONFIG_DIR/Code/User"
ZED_DIR="$CONFIG_DIR/zed"
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
  "sioyek"
  "zathura"
  "MangoHud"
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
rsync -aq "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
mkdir -p "$CONFIG_DIR/opencode"
rsync -aq "$DOTFILES_DIR/opencode/opencode.jsonc" "$CONFIG_DIR/opencode/opencode.jsonc"
mkdir -p "$CONFIG_DIR/opencode/skills"
rsync -aq --delete "$DOTFILES_DIR/opencode/skills/" "$CONFIG_DIR/opencode/skills/"
rsync -aq --delete "$DOTFILES_DIR/claude/skills/" "$HOME/.claude/skills/"
rsync -aq "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
rsync -aq "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
rsync -aq "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
tmp=$(mktemp)
jq --slurpfile mcp "$DOTFILES_DIR/claude/mcp-servers.json" '.mcpServers = $mcp[0]' "$HOME/.claude.json" > "$tmp" && mv "$tmp" "$HOME/.claude.json"

# ---------------------------------------------------------
# 3. VS Code + Zed Settings
# ---------------------------------------------------------
echo ">>> Syncing VS Code..."
mkdir -p "$CODE_DIR"
# rsync -aq "$DOTFILES_DIR/vscode/settings.json" "$CODE_DIR/"
# rsync -aq "$DOTFILES_DIR/vscode/keybindings.json" "$CODE_DIR/"

echo ">>> Syncing zed..."
mkdir -p "$ZED_DIR"
rsync -aq "$DOTFILES_DIR/zed/settings.json" "$ZED_DIR/"
rsync -aq "$DOTFILES_DIR/zed/keymap.json" "$ZED_DIR/"

# ---------------------------------------------------------
# 4. Scripts
# ---------------------------------------------------------
echo ">>> Syncing Scripts..."
mkdir -p "$SCRIPTS_DIR"
rsync -aq --delete "scripts/" "$SCRIPTS_DIR/"

echo ">>> Dotfiles installation complete!"
