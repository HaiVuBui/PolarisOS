{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  isNm = config.polaris.network == "nm";
  isIwd = config.polaris.network == "iwd";
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

    # keep nm-connection-editor, drop the tray applet: /etc/xdg wins over the
    # package's own autostart entry in XDG_CONFIG_DIRS
    environment.etc."xdg/autostart/nm-applet.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=NetworkManager Applet
      Exec=nm-applet
      Hidden=true
    '';
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
