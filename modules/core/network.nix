{ host, lib, pkgs, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
  isNm = vars.network == "nm";
  isIwd = vars.network == "iwd";

  # Assume vars.cores exists
  threads = lib.max 1 vars.cores;

  # next power-of-two >= n (good "close to num-threads" choice for slabs)
  nextPow2 =
    n:
    let
      go = p: if p >= n then p else go (p * 2);
    in
    go 1;

  slabs = nextPow2 threads;
in
lib.mkMerge [
  {
    networking.hostName = host;

    # 1) TCP Optimization
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    # 2) Single-layer DNS: Unbound (local cache) -> fast forwarders
    services.unbound = {
      enable = true;

      # Adds localhost to resolv.conf for local queries on NixOS :contentReference[oaicite:2]{index=2}
      resolveLocalQueries = true;

      settings = {
        server = {
          interface = [ "127.0.0.1" "::1" ];
          access-control = [ "127.0.0.0/8 allow" "::1 allow" ];

          # Unbound tuning guidance: threads = cores, slabs ~ power-of-two near threads :contentReference[oaicite:3]{index=3}
          num-threads = threads;
          msg-cache-slabs = slabs;
          rrset-cache-slabs = slabs;
          infra-cache-slabs = slabs;
          key-cache-slabs = slabs;

          # "Snappy" browsing knobs (still safe)
          prefetch = true;
          prefetch-key = true;

          serve-expired = true;
          serve-expired-ttl = 21600;        # 6h
          serve-expired-client-timeout = 0; # serve immediately

          cache-min-ttl = 0;                # don't force long staleness
          cache-max-ttl = 86400;

          # Reasonable desktop cache sizes (bump if you have lots of RAM)
          msg-cache-size = "32m";
          rrset-cache-size = "64m";
        };

        # Forwarding = fastest cold lookups, local cache speeds repeats
        forward-zone = [{
          name = ".";
          forward-first = true;
          forward-addr = [
            "1.1.1.1" "1.0.0.1"
            "9.9.9.9"
          ];
        }];
      };
    };

    # Avoid double caching layers
    services.resolved.enable = false;
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
