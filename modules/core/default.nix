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
    # (if vars.displayManager == "tui" then ./greetd.nix else ./sddm.nix)
    ./greetd.nix
    ./security.nix
    ./services.nix
    # ./stylix.nix
    ./system.nix
    ./thunar.nix
    ./user.nix
    ./nopass.nix
    ./docker.nix
    ./nixld.nix
  ];
}
