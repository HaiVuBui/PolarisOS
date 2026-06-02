{
  host,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../../hosts/${host}/variables.nix;
  isNm = vars.network == "nm";
  isIwd = vars.network == "iwd";
in
lib.mkMerge [
  {
    networking = {
      hostName = host;
      useDHCP = lib.mkDefault false;
    };
    services.resolved.enable = true;
  }

  (lib.mkIf isNm {
    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    environment.systemPackages = [ pkgs.networkmanagerapplet ];
  })

  (lib.mkIf isIwd {
    networking = {
      useNetworkd = true;
      wireless.iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = false;
      };
    };
    systemd.network.networks."25-wlan" = {
      matchConfig.Type = "wlan";
      networkConfig.DHCP = "yes";
      dhcpV4Config.RouteMetric = 20;
    };
    environment.systemPackages = [ pkgs.impala ];
  })
]
