{
  pkgs,
  config,
  lib,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      systemd.enable = true;
      supportedFilesystems = [ "btrfs" ];
    };

    loader = {
      timeout = 3;
      systemd-boot.enable = true;
    };
  };
}
