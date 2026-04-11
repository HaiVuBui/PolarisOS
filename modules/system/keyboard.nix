{ pkgs, ... }: # Ensure this line has 'pkgs' inside the { }

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-bamboo
      fcitx5-gtk
    ];
  };

  # We use 'environment.variables' directly to match the system module exactly.
  # We use 'pkgs.lib.mkForce' to guarantee this overrides the default "fcitx".
  environment.variables = {
    GTK_IM_MODULE = pkgs.lib.mkForce "";
  };

  # These can stay in sessionVariables or variables, doesn't matter much.
  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
