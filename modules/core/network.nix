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
    networking.hostName = host;

  }

  (lib.mkIf isNm {
    networking.networkmanager.enable = true;
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
    environment.systemPackages = [ pkgs.impala ];
  })
]
