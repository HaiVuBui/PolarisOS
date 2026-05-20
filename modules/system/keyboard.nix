{ pkgs, inputs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
    ];
  };

  services.fcitx5-lotus = {
    enable = true;
    users = [ "hai" ];
    package = pkgs.callPackage "${inputs.fcitx5-lotus}/nix/packages/fcitx5-lotus/default.nix" {
      extra-cmake-modules = null;
      kdePackages = pkgs.kdePackages;
    };
  };

  environment.variables = {
    GTK_IM_MODULE = pkgs.lib.mkForce "";
  };

  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
