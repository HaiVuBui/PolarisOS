{ profile, pkgs, lib, ... }: {
  programs.fish = {
    enable = true;
    # plugins = [
    #   {
    #     name = "tide";
    #     src = pkgs.fishPlugins.tide.src;
    #   }
    #   {
    #     name = "fzf-fish";
    #     src = pkgs.fishPlugins.fzf-fish.src;
    #   }
    # ];
  };

}
