{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.polaris = {
    git = {
      username = mkOption {
        type = types.str;
        description = "Git user name, also used as the system user's description.";
      };
      email = mkOption {
        type = types.str;
        description = "Git user email.";
      };
    };

    network = mkOption {
      type = types.enum [
        "iwd"
        "nm"
      ];
      default = "iwd";
      description = "Network backend: iwd (+systemd-networkd) or NetworkManager.";
    };

    displayManager = mkOption {
      type = types.enum [
        "tui"
        "graphical"
      ];
      default = "tui";
      description = "Login manager style.";
    };

    cores = mkOption {
      type = types.ints.unsigned;
      default = 0;
      description = "Cores per Nix build job (0 = use all available).";
    };

    stylixImage = mkOption {
      type = types.path;
      description = "Wallpaper that drives the Stylix colour scheme.";
    };

    nopasswdSudo = mkEnableOption "passwordless sudo for the primary user";

    features = {
      cuda = mkEnableOption "the CUDA toolkit";
      gaming = mkEnableOption "the gaming subsystem (Steam, gamemode, gamescope)";
      jellyfin = mkEnableOption "the Jellyfin media server";
      vaultwarden = mkEnableOption "Vaultwarden exposed via Tailscale Serve";
      floccus = mkEnableOption "Floccus WebDAV bookmark sync via Tailscale Serve";
      archive = mkEnableOption "the monthly /Archive Btrfs healthcheck";
    };
  };
}
