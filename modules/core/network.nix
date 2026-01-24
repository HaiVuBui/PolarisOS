{ host, lib, pkgs, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
  isNm = vars.network == "nm";
  isIwd = vars.network == "iwd";
in lib.mkMerge [
  {
    networking.hostName = host;

  }

  (lib.mkIf isNm {
    networking.networkmanager.enable = true;
    environment.systemPackages = [ pkgs.networkmanagerapplet ];

    # Stop NM from rewriting resolv.conf (so Unbound stays in charge) :contentReference[oaicite:4]{index=4}
    networking.networkmanager.dns = "none";
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
