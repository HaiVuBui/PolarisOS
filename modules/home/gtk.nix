{ pkgs, config, ... }:

{
  gtk = {
    # enable = true;
    # theme = {
    #   name = "Everforest-Light";
    #   package = pkgs.everforest-gtk-theme;
    # };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 0;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 0;
    };
    gtk4.theme = config.gtk.theme;
  };
}
