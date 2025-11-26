{ pkgs, config, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.systemd-boot.enable = true;
}
