{ pkgs, ... }: {

  # docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };
  systemd.user.sockets.podman = {
    enable = true;
    wantedBy = [ "sockets.target" ];
  };

  environment.systemPackages = [ pkgs.distrobox];
}

