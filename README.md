# PolarisOS

Flake-based NixOS configuration for hai's machines, with per-host settings, GPU-specific profiles, and bundled dotfiles/scripts for day-to-day setup.

## Layout
- `flake.nix` – defines inputs (home-manager, Stylix, nix-flatpak, zen-browser) and exports NixOS configurations for `MovingCastle-intel` and `MinasTirith-nvidia`.
- `profiles/` – GPU profiles that compose host configs with shared core modules.
- `hosts/` – hardware configs, host-specific modules, and package lists.
- `modules/core` – common NixOS modules (network, security, stylix, flatpak, docker, gaming, etc.).
- `modules/home` – home-manager modules for apps and theming.
- `dotfiles/` – editor/terminal/WM settings; `scripts/` – helper scripts; `wallpapers/` – curated wallpaper sets.

## Prerequisites
- Nix with `flakes` and `nix-command` enabled.
- Run commands from the repo root (`/home/hai/PolarisOS`).

## Deploy
- Choose a host/GPU target defined in `flake.nix` (e.g., `MovingCastle-intel`, `MinasTirith-nvidia`).
- Rebuild/switch the system:
  ```bash
  sudo nixos-rebuild switch --flake .#MovingCastle-intel
  ```
- Inspect available outputs:
  ```bash
  nix flake show .
  ```
- Update inputs:
  ```bash
  nix flake update
  ```

## Dotfiles & Extras
- Sync dotfiles, VS Code settings, scripts, and wallpapers into `$HOME`:
  ```bash
  ./scripts/sync.sh
  ```
- Pick a wallpaper via rofi and set it with swww (defaults to `~/Wallpapers`):
  ```bash
  ./scripts/wppicker.sh [DIR]
  ```
- User/account defaults live in `flake.nix` (`username = "hai"`); adjust if cloning for another user.

## Notes
- Host-specific toggles live in `hosts/<Host>/modules/` (power, storage, GPU driver flags, etc.).
- Core modules are commented for enabling/disabling drivers; edit the relevant profile under `profiles/` when changing GPU setups.
