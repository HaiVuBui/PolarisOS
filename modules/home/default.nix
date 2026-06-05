{ host, lib, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
in
{
  imports = [
    ./fish.nix
    ./vscode.nix
    ./git.nix
    ./applications.nix
    ./mpd.nix
    ./stylix.nix
    ./env.nix
    ./symlinks.nix
    ./direnv.nix
    ./vdirsyncer.nix
    ./niri.nix
  ]
  ++ lib.optionals (vars.gamingEnable or false) [
    ./gaming.nix
  ];
}
