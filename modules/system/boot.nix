{
  pkgs,
  config,
  lib,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = false;

    loader.systemd-boot = {
      enable = true;
      editor = true;
    };

  };
}
