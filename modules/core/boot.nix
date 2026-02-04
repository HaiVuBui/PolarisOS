{ pkgs, config, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader.systemd-boot = {
      enable = true;
      editor = true;
    };

    # plymouth.enable = true;
    # plymouth.theme = "stylix";

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=0"
      "rd.systemd.show_status=auto"
      "systemd.show_status=false"
      "udev.log_priority=0"
    ];

    consoleLogLevel = 3;
  };

  # --- THE "BIOS BYPASS" MAGIC ---
  # This script runs every time you rebuild. 
  # It forces the EFI Shell binary into your boot partition.
  system.activationScripts.installEfiShell = {
    text = ''
      # Copy the shell binary to the specific name systemd-boot looks for
      cp -f ${pkgs.edk2-uefi-shell}/shell.efi /boot/shellx64.efi
    '';
  };
}
