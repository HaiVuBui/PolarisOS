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
      systemd.emergencyAccess = true;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "btrfs"
      ];
    };

    loader.systemd-boot = {
      enable = true;
    };
    kernelParams = [ "rd.systemd.debug_shell=1" ];

  };
}
