{ config, pkgs, ... }:

{
  # --- Cursor (applies to GTK/Qt/Wayland) ---
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";     # or any installed cursor name
    package = pkgs.bibata-cursor-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;               # harmless even if you don’t use X11
  };

  # --- Fonts (optional but nice to unify) ---
  fonts.fontconfig.enable = true;

  # --- GTK theming ---
  gtk = {
    enable = true;

    # GTK3: theme + icons
    theme = {
      name = "adw-gtk3";            # matches GNOME/Libadwaita look
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # Prefer dark for GTK3
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
      "gtk-font-name" = "Inter 10"; # example
      "gtk-cursor-theme-name" = "Bibata-Modern-Ice";
    };
  };

  # Dark preference for GTK4 (Libadwaita reads this)
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";    # or "default"
    cursor-theme = "Bibata-Modern-Ice";
    font-name = "Inter 10";
    icon-theme = "Papirus-Dark";
  };

  # --- Qt theming ---
  qt = {
    enable = true;

    # Make Qt follow Adwaita look and feel
    style = {
      name = "adwaita-dark";         # "adwaita" if you prefer light
      package = pkgs.adwaita-qt;     # covers Qt5/Qt6 via Nixpkgs
    };

    # Let Qt pick up GTK settings for e.g. file dialogs; if you prefer
    # qt6ct/qt5ct control instead, set platformTheme = "qt6ct".
    platformTheme = "gtk3";
  };

  # If you want guaranteed control via qt6ct/qt5ct instead of gtk3:
  # home.sessionVariables = {
  #   QT_QPA_PLATFORMTHEME = "qt6ct";    # Qt6
  #   QT_STYLE_OVERRIDE = "adwaita-dark";# optional if you set in qt6ct GUI
  # };
  # programs.qt6ct.enable = true;        # Home Manager option (if available)

  # --- (Optional) Electron/Chromium apps prefer Wayland ---
  home.sessionVariables = {
    # Some apps read this only if set in user env (in addition to system)
    NIXOS_OZONE_WL = "1";
  };
}

