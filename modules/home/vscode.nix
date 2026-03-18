{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          # python
          ms-python.python
          ms-toolsai.jupyter

          # themes
          catppuccin.catppuccin-vsc
          sainnhe.gruvbox-material

          # vscodevim.vim
          asvetliakov.vscode-neovim

        ];
      };
    };
  };
}
