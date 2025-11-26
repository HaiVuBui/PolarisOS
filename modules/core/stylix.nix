{ pkgs
, host
, ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) stylixImage;
in
{
  # Styling Options
  stylix = {
    enable = true;
    image = stylixImage;
  #   base16Scheme = {
  #   base00 = "fbf1c7"; # background (light0)
  #   base01 = "f2e5bc"; # lighter background (light0_soft)
  #   base02 = "ebdbb2"; # selection bg / comments
  #   base03 = "d5c4a1"; # subtle text
  #   base04 = "bdae93"; # muted text
  #   base05 = "504945"; # main text / fg (inverted dark)
  #   base06 = "3c3836"; # strong text
  #   base07 = "282828"; # very dark (used for fg in light themes)
  #   base08 = "9d0006"; # red
  #   base09 = "af3a03"; # orange
  #   base0A = "b57614"; # yellow
  #   base0B = "79740e"; # green
  #   base0C = "427b58"; # aqua / cyan
  #   base0D = "076678"; # blue
  #   base0E = "8f3f71"; # purple
  #   base0F = "d65d0e"; # brown / extra accent
  # };

    polarity = "light";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}

