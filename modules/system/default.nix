{
  inputs,
  host,
  lib,
  ...
}:
let
  # Import the host-specific variables.nix
  vars = import ../../hosts/${host}/variables.nix;
in
{
  imports = [
    ./brave.nix
    ./boot.nix
    ./firewall.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware.nix
    ./network.nix
    ./keyboard.nix
    ./jellyfin.nix
    ./packages.nix
    ./tuigreet.nix
    ./security.nix
    ./services.nix
    ./tailscale.nix
    ./stylix.nix
    inputs.stylix.nixosModules.stylix
    ./system.nix
    # ./thunar.nix
    ./user.nix
    ./nopass.nix
    ./kmscon.nix
    ./syncthing.nix
    # ./snapper.nix
    ./virtualization.nix
    # ./tmux.nix
    ./nix.nix
    ./nix-ld.nix
    ./zram.nix
    ./xdg.nix
    ./systemEnv.nix
  ]
  ++ lib.optionals (vars.gamingEnable or false) [
    ./gaming.nix
  ];
}
