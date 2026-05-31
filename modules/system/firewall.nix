{ host, lib, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) jellyfinEnable;
in
{
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = lib.optionals jellyfinEnable [ 8096 ];
  };
}
