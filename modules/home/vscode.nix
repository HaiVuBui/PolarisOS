{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          # python
          # ms-python.python

          # themes
          sainnhe.gruvbox-material

          # vscodevim.vim
          asvetliakov.vscode-neovim

        ];
      };
    };
  };
}
