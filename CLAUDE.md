# CLAUDE.md

PolarisOS is a declarative NixOS configuration managing two machines: **MovingCastle** (Intel dev machine) and **MinasTirith** (NVIDIA server/gaming). Uses NixOS + Home Manager with Nix flakes.

## Key commands

```bash
nh os switch                  # Rebuild and switch to new system config
nh os test                    # Test build without switching
nh clean all                  # Clean old generations (keeps last 3 + 4 days)
./scripts/sync.sh             # Sync dotfiles from repo to ~/.config/
./scripts/clean.sh            # Clean Nix store, optimize, defrag Btrfs
```

No build checks, tests, or lint — changes are validated by `nh os switch` succeeding.

## Architecture

```
flake.nix                   # Entry point — defines both host systems
modules/options.nix         # Typed `polaris.*` option set (host config surface)
hosts/{host}/
  default.nix               # Host-level imports + `polaris.*` values for this host
  hardware.nix              # Device-specific (UUIDs, drivers)
modules/system/             # Shared NixOS system-level modules
modules/home/               # Shared Home Manager user-level modules
dotfiles/                   # App configs synced by sync.sh to ~/.config/
```

### Host configuration (`polaris.*` options)

Typed options defined in `modules/options.nix`, set per-host in `hosts/{host}/default.nix` under `polaris`. Key options:
- `polaris.features.{cuda,gaming,jellyfin,vaultwarden,floccus,archive}` — toggle subsystems
- `polaris.network` — `"iwd"` or `"nm"`
- `polaris.displayManager` — `"tui"` or `"graphical"`
- `polaris.nopasswdSudo` — passwordless sudo
- `polaris.cores` — Nix build cores per job (`0` = all)
- `polaris.git.{username,email}` — git identity and system user description
- `polaris.stylixImage` — wallpaper that drives the Stylix color scheme

System modules read these via `config.polaris.*`; Home Manager modules via `osConfig.polaris.*`. Feature modules are always imported and gate their bodies with `lib.mkIf config.polaris.features.<name>`.

MovingCastle has no CUDA/gaming; MinasTirith has NVIDIA drivers, CUDA, Jellyfin, and gaming packages.

### Module pattern

Modules under `modules/system/` and `modules/home/` are opt-in via imports in `hosts/{host}/default.nix`. Home Manager runs as a NixOS module (not a standalone flake output).

### Dotfiles sync

`scripts/sync.sh` rsyncs `dotfiles/` to `~/.config/`. Mutable configs (e.g., `~/.config/fish/cfg.fish`) can be edited live without rebuilding. The nvim config is a git submodule (`git@github.com:HaiVuBui/nvim.git`).

### Gaming configs

Lutris game YAMLs (`~/.local/share/lutris/games/*.yml`) are **not synced** — Lutris rewrites them on every settings change. Do not add them to `scripts/sync.sh`.

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

In-game: Renderer=Vulkan, Engine Multithreading=On, Dynamic Culling=On, Shadow Quality=Low, Texture Quality=High (not Ultra), VSync=Off.

### Key inputs

- `nixpkgs` (unstable) — primary package source
- `home-manager` — user environment
- `stylix` — unified theming across all apps
- `niri` (git) — Wayland compositor, installed from upstream
