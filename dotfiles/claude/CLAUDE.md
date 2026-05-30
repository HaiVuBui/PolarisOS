# Global Claude Instructions

## System
- NixOS (PolarisOS) with two machines: MovingCastle (Intel dev) and MinasTirith (NVIDIA/gaming)
- Shell: fish. Suggest fish-compatible syntax for interactive commands; POSIX sh is fine for scripts
- Rebuild: `nh os switch` — this is how NixOS config changes are applied
- Editor: neovim, terminal: kitty, compositor: niri (Wayland)

## Response style
- Terse and direct. No preamble, no trailing summaries
- No emojis
- Surgical changes only — don't touch code outside the scope of the request
- No speculative features, abstractions, or error handling for impossible cases
- No comments unless the why is genuinely non-obvious
