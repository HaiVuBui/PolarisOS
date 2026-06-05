{ pkgs, config, ... }:

{
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-light";

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-latte-blue-standard";
      package = pkgs.catppuccin-gtk.override {
        variant = "latte";
        accents = [ "blue" ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 0;
    };
    gtk4.theme = config.gtk.theme;
  };
}
