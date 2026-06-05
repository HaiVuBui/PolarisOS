{ lib, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "qtct";
  };

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=kvantum

    [Fonts]
    fixed="JetBrainsMono Nerd Font Mono,12"
    general="Noto Serif,12"
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=kvantum

    [Fonts]
    fixed="JetBrainsMono Nerd Font Mono,12"
    general="Noto Serif,12"
  '';
}
