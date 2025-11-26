{pkgs, ...}:
{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=WaylandWindowDecorations"
    ];
    # # env for Brave only
    # package = pkgs.wrapProgram pkgs.brave {
    #   inherit (pkgs) makeWrapper;
    #   extraArgs = [ "--set GTK_USE_PORTAL 0" ];
    # };
  };
}

