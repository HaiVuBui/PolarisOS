{ host, ... }:
{
  imports = [
    # ./zsh.nix
    ./fish.nix
    ./vscode.nix
    ./git.nix
    # ./pixi.nix
    ./gaming.nix
    ./applications.nix
    ./mpd.nix
    ./stylix.nix
    ./qt.nix
    ./gtk.nix
    ./env.nix
    ./brave.nix
    # ./zen.nix
    ./symlinks.nix
    ./direnv.nix
    # ./yazi.nix
    ./vdirsyncer.nix
  ];
}
