{ profile, pkgs, lib, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Source the local, mutable config file if it exists
      if test -f ~/.config/fish/cfg.fish
        source ~/.config/fish/cfg.fish
      end
    '';
  };
}
