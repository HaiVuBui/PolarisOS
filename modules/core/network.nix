{ host, lib, pkgs, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
  isNm = vars.network == "nm";
  isIwd = vars.network == "iwd";
in lib.mkMerge [
  {
    networking.hostName = host;
    boot.kernel.sysctl = {
      # The "Queueing Discipline" - required for BBR to work
      "net.core.default_qdisc" = "fq";
      # The actual Algorithm
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
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
