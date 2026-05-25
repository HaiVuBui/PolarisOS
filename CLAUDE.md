# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

PolarisOS is a declarative NixOS configuration managing two machines: **MovingCastle** (Intel dev machine) and **MinasTirith** (NVIDIA server/gaming). It uses NixOS + Home Manager with Nix flakes.

## Key commands

```bash
nh os switch                  # Rebuild and switch to new system config
nh os test                    # Test build without switching
nh clean all                  # Clean old generations (keeps last 3 + 4 days)
./scripts/sync.sh             # Sync dotfiles from repo to ~/.config/
./scripts/clean.sh            # Clean Nix store, optimize, defrag Btrfs
```

There are no build checks, tests, or lint commands — changes are validated by `nh os switch` succeeding.

## Architecture

```
flake.nix                   # Entry point — defines both host systems
hosts/{host}/
  default.nix               # Host-level imports and variables.nix values
  hardware.nix              # Device-specific (UUIDs, drivers)
  variables.nix             # Feature flags for this host
modules/system/             # Shared NixOS system-level modules
modules/home/               # Shared Home Manager user-level modules
dotfiles/                   # App configs synced by sync.sh to ~/.config/
```

### Host feature flags (`variables.nix`)

Each host's `variables.nix` controls which features are enabled. Key flags:
- `cudaEnable`, `gamingEnable`, `jellyfinEnable` — toggle entire subsystems
- `displayManager` — `"tui"` or graphical
- `nopasswdSudo` — passwordless sudo
- `cores` — parallelism for Nix builds
- `stylixImage` — wallpaper that drives the Stylix color scheme

MovingCastle has no CUDA/gaming; MinasTirith has NVIDIA drivers, CUDA, Jellyfin, and gaming packages.

### Module pattern

Modules under `modules/system/` and `modules/home/` are opt-in via imports in `hosts/{host}/default.nix`. Home Manager config lives entirely under `modules/home/` and is integrated as a NixOS module (not standalone).

### Dotfiles sync

`scripts/sync.sh` uses `rsync` to copy from `dotfiles/` to `~/.config/`. Mutable configs (e.g., `~/.config/fish/cfg.fish`) can be edited live without rebuilding. The nvim config is a git submodule (`git@github.com:HaiVuBui/nvim.git`).

### Lutris / gaming configs

Lutris game YAMLs (`~/.local/share/lutris/games/*.yml`) are **not synced** — Lutris writes them live on every settings change. Do not add them to `scripts/sync.sh`.

The PoE entry is `~/.local/share/lutris/games/poe-*.yml`. Key settings to preserve if recreating:

```yaml
system:
  env:
    DXVK_LOG_LEVEL: none
    WINEDEBUG: -all
    WINEESYNC: '0'
    WINEFSYNC: '0'
    WINENTSYNC: '1'              # ntsync — kernel 6.14+ required
    __GL_MaxFramesAllowed: '1'   # NVIDIA 1-frame queue, reduces input lag
    STAGING_SHARED_MEMORY: '1'
    STAGING_WRITECOPY: '1'
    MANGOHUD: '1'
    MANGOHUD_DLSYM: '1'
    DXVK_GPLASYNC_CACHE_PATH: /home/hai/.cache/dxvk-gplasync
  gamemode: true
wine:
  esync: false
  fsync: false
  version: wine-ge-8-26-x86_64
```

In-game graphics settings: Renderer=Vulkan, Engine Multithreading=On, Dynamic Culling=On, Shadow Quality=Low, Texture Quality=High (not Ultra), VSync=Off.

### Key inputs

- `nixpkgs` (unstable) — primary package source
- `home-manager` — user environment
- `stylix` — unified theming across all apps
- `niri` (git) — Wayland compositor, installed from upstream
- `nix-flatpak` — declarative Flatpak management
