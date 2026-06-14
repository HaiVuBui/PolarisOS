---
name: os-config
description: Update OS/app config for PolarisOS. Edits go into dotfiles/ in the repo, then sync.sh ships them to ~/.config/. Also covers claude-code config (dotfiles/claude/).
license: MIT
---

# OS Config Update

When the user asks to edit any app config, OS setting, or claude-code config in PolarisOS:

## Rule

**Never edit files directly in `~/.config/` or `~/.claude/`.** Always edit the source in the repo's `dotfiles/` directory, then run `./scripts/sync.sh` to deploy.

## Mapping

| Live location | Repo source |
|---|---|
| `~/.config/<app>/` | `dotfiles/<app>/` |
| `~/.config/fish/cfg.fish` | `dotfiles/fish/cfg.fish` |
| `~/.ssh/config` | `dotfiles/ssh/config` |
| `~/.vimrc` | `dotfiles/.vimrc` |
| `~/.claude/skills/` | `dotfiles/claude/skills/` |
| `~/.claude/agents/` | `dotfiles/claude/agents/` |
| `~/.claude/hooks/` | `dotfiles/claude/hooks/` |
| `~/.claude/settings.json` | `dotfiles/claude/settings.json` |
| `~/.claude/CLAUDE.md` | `dotfiles/claude/CLAUDE.md` |
| `~/.config/opencode/` | `dotfiles/opencode/` |
| `~/.config/zed/` | `dotfiles/zed/` |

For apps listed in sync.sh's `APPS` array (hypr, niri, nvim, kitty, tmux, waybar, fastfetch, rofi, htop, rmpc, swaync, lazygit, lazydocker, khal, btop, yazi, sioyek, zathura, MangoHud), the pattern is always `dotfiles/<app>/`.

## Steps

1. Edit the file(s) under `dotfiles/` in `/home/hai/PolarisOS/`
2. Run `cd /home/hai/PolarisOS && ./scripts/sync.sh` to deploy
3. Confirm what was changed and deployed

## Notes

- `aerc/accounts.conf` is excluded from sync (contains secrets) — never edit it via this flow
- Lutris game YAMLs are not synced — do not add them
- `sync.sh` must be run from the repo root (`/home/hai/PolarisOS/`)
- NixOS system-level changes (packages, services) go in `modules/` or `hosts/` — those require `nh os switch`, not sync.sh
