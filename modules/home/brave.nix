{ ... }:
{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=WaylandWindowDecorations"
    ];
  };
}
