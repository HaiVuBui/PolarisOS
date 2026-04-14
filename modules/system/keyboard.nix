{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-bamboo
      fcitx5-gtk
    ];
  };

  environment.variables = {
    GTK_IM_MODULE = pkgs.lib.mkForce "";
  };

  # These can stay in sessionVariables or variables, doesn't matter much.
  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

}
