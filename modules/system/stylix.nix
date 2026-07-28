{ pkgs, config, ... }:
{
  # Styling Options
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    image = config.polaris.stylixImage;
    autoEnable = false;
    targets = {
      plymouth.enable = false;
      fish.enable = false;
      console.enable = false;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";

    polarity = "light";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    icons = {
      enable = true;
      package = pkgs.tela-icon-theme;
      light = "Tela-light";
      dark = "Tela-dark";
    };
  };
}
