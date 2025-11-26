{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

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

          # vim 
          # vscodevim.vim
          asvetliakov.vscode-neovim

        ];
        # userSettings = {
        #   "editor.fontFamily" = "JetBrainsMono Nerd Font, monospace";
        #   "extensions.experimental.affinity" = {
        #     "asvetliakov.vscode-neovim" = 1;
        #   };
        #   "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
        #   "terminal.external.linuxExec" = "kitty";
        #   "terminal.external.osxExec" = "kitty";
        #   "terminal.external.windowsExec" = "kitty";
        #   "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
        #   "workbench.colorTheme" = "Gruvbox Material Dark";
        #   "workbench.secondarySideBar.defaultVisibility" = "hidden";
        #   "editor.lineNumbers" = "relative";
        #   "vim.relativeNumbers" = true;
        #   "vim.useCtrlKeys" = true;
        #   "workbench.sideBar.location" = "right";
        #   "editor.minimap.enabled"= false;
        #
        #   "editor.scrollbar.vertical" = "auto";
        #   "editor.scrollbar.horizontal" = "auto";
        #   "editor.scrollbar.verticalScrollbarSize" = 0;
        #   "editor.scrollbar.horizontalScrollbarSize" = 0;
        #
        # };
      };
    };
  };
}
