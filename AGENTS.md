# Repository Guidelines

This repo contains a Nix flake for NixOS and Home Manager configuration. Keep changes modular, reproducible, and host‑aware.

## Project Structure & Module Organization
- `flake.nix`: Entry point; defines `nixosConfigurations` for `intel` and `nvidia` profiles and passes `host`, `profile`, and `username` to modules.
- `profiles/<gpu>/default.nix`: High‑level profile that imports the active host and core modules (e.g., `profiles/intel/default.nix`).
- `hosts/<HostName>/`: Host‑specific `hardware.nix`, `host-packages.nix`, `variables.nix`, and `modules/`.
- `modules/core/`: System modules grouped by concern (e.g., `network.nix`, `services.nix`, `user.nix`).
- `modules/home/`: Home Manager modules imported by `modules/core/user.nix`.
- `dotfiles/`, `scripts/`, `wallpapers/`: User assets and helper scripts.

## Build, Test, and Development Commands
- Dry build (no switch): `nix build .#nixosConfigurations.intel.config.system.build.toplevel`
- Switch to a profile: `sudo nixos-rebuild switch --flake .#intel` (or `.#nvidia`)
- Check flake health: `nix flake check`
- Update inputs: `nix flake update`

## Coding Style & Naming Conventions
- Nix files: 2‑space indentation, no tabs; prefer short, focused modules.
- Filenames: lower‑case with hyphens where needed (e.g., `host-packages.nix`).
- Keep options and imports alphabetized where practical; avoid unused attrs.
- Format Nix: prefer `nixpkgs-fmt` or `alejandra` if available.

## Testing Guidelines
- Build both profiles locally: see “Dry build” command for `intel` and `nvidia`.
- Switching applies Home Manager via `modules/core/user.nix`; no separate HM call needed.
- For UI/dotfile changes (e.g., Hyprland, Waybar, Rofi), attach screenshots and verify scripts in `scripts/` run without errors.

## Commit & Pull Request Guidelines
- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`; optional scope (e.g., `feat(core/network): enable mDNS`).
- PRs must include: summary, rationale, affected hosts/profiles, test/build output, and screenshots for UX changes.
- Link related issues and note any follow‑ups or rollbacks.

## Security & Configuration Tips
- Do not commit secrets. Keep tokens and private data out of `variables.nix`; use external secret management if needed.
- Host additions: create `hosts/<NewHost>/` with `hardware.nix`, `variables.nix`, and import via `profiles/<gpu>/default.nix`; update `flake.nix` only if introducing new outputs.
