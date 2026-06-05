{ pkgs, ... }:
let
  qtctConf = ver: ''
    [Appearance]
    color_scheme_path=${pkgs.catppuccin-qt5ct}/share/${ver}/colors/catppuccin-latte-blue.conf
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=Fusion

    [Fonts]
    fixed="JetBrainsMono Nerd Font Mono,12"
    general="Noto Serif,12"
  '';
in
{
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  xdg.configFile."qt5ct/qt5ct.conf".text = qtctConf "qt5ct";
  xdg.configFile."qt6ct/qt6ct.conf".text = qtctConf "qt6ct";
}
