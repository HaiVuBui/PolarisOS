{ pkgs
, host
, options
, ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) hostId;
in
{
  networking = {
    hostName = "${host}";
    # hostId = hostId;
    networkmanager.enable = false;
    # useDHCP = false;
    # useNetworkd = true;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true; # Allows iwd to assign IP addresses
    };
    # timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    # firewall = {
    #   enable = true;
    #   allowedTCPPorts = [
    #     22
    #     80
    #     443
    #     59010
    #     59011
    #     8080
    #   ];
    #   allowedUDPPorts = [
    #     59010
    #     59011
    #   ];
    # };
  };

  # systemd.network = {
  #   enable = true;
  #   networks."10-wired" = {
  #     matchConfig.Name = "en*"; # Matches "enp3s0", "eth0", etc.
  #     networkConfig.DHCP = "yes";
  #   };
  #   wait-online.enable = false;
  # };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
