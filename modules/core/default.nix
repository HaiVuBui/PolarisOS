{
  inputs,
  host,
  ...
}:
let
  # Import the host-specific variables.nix
  vars = import ../../hosts/${host}/variables.nix;
in
{
  imports = [
    ./boot.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware.nix
    ./network.nix
    ./keyboard.nix
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
    ./pixi.nix
    ./zram.nix
    ./xdg.nix
  ];
}
