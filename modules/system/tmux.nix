{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    tmux
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux

      set -g @continuum-restore 'on'
      set -g @resurrect-capture-pane-contents 'on'

      # Add lazygit and lazydocker to the restore list
      # The quotes are important!
      set -g @resurrect-processes 'ssh azygit lazydocker'
    '';
  };
}
