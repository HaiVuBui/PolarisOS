{ pkgs, config, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader.systemd-boot.enable = true;

    plymouth.enable = true;
    plymouth.theme = "stylix"; # match Stylix theming

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
}
