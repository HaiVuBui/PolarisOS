{ host, ... }:
# let
#   inherit (import ../../hosts/${host}/variables.nix)
#     alacrittyEnable
#     ghosttyEnable
#     tmuxEnable
#     waybarChoice
#     weztermEnable
#     vscodeEnable
#     helixEnable
#     doomEmacsEnable
#     ;
# in
{
  imports = [
    ./zsh.nix
    ./vscode.nix
    ./git.nix
    # ./pixi.nix
    ./gaming.nix
    ./applications.nix
    ./mpd.nix
    ./stylix.nix
    ./qt.nix
    ./gtk.nix
    ./brave.nix
    ./zen.nix
    ./symlinks.nix
  ];
}
