{
  profile,
  pkgs,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
    };
    initContent = 
    lib.mkBefore ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Helpful aliases

      # Directory navigation shortcuts
      alias ..='cd ..'
      alias ...='cd ../..'
      alias .3='cd ../../..'
      alias .4='cd ../../../..'
      alias .5='cd ../../../../..'

      # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
      alias mkdir='mkdir -p'

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh  

      export PATH=$HOME/.local/bin:$PATH

      alias n='nvim'

    '';
  };
}
