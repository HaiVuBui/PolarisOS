{ pkgs, host, ... }:
let inherit (import ../../hosts/${host}/variables.nix) stylixImage;
in {
  # Styling Options
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    image = stylixImage;
    autoEnable = false;
    targets ={
      plymouth.enable = false;
      fish.enable = false;
      console.enable = false;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";

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
        name = "JetBrainsMono Nerd Font Mono";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Inter";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Noto Serif";
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
