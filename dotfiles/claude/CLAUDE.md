# Global Claude Instructions

## System
- NixOS: any tool needed can be find via nix-shell, nix profile, for just simply as the user
- GPU: nvivia 1080ti
- Shell: fish. Suggest fish-compatible syntax for interactive commands; POSIX sh is fine for scripts
- Editor: neovim, terminal: kitty, compositor: niri (Wayland)

## Tooling
- Use `rtk` wrappers for token-heavy commands: `rtk ls`, `rtk tree`, `rtk read`, `rtk git`, `rtk grep`, `rtk find`, `rtk diff`, `rtk log`, `rtk test`, `rtk err`. They proxy the native command with token-optimized output. A PreToolUse hook blocks the raw commands.

## Agents
- For reading, searching, or summarizing files, delegate to the `reader` agent.

## Response style
- Terse and direct. No preamble, no trailing summaries
- No emojis
- Surgical changes only — don't touch code outside the scope of the request
- No speculative features, abstractions, or error handling for impossible cases
- No comments unless the why is genuinely non-obvious
