{
  host,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) floccusEnable;
in
lib.mkIf floccusEnable {
  systemd.services.floccus-webdav = {
    description = "rclone WebDAV server for floccus bookmark sync";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = username;
      # idempotent — creates secret:Floccus/ if it doesn't exist yet
      ExecStartPre = "-${pkgs.rclone}/bin/rclone mkdir secret:Floccus";
      ExecStart = "${pkgs.rclone}/bin/rclone serve webdav secret:Floccus --addr 127.0.0.1:8333 --vfs-cache-mode minimal";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  systemd.services.floccus-serve = {
    description = "Expose floccus WebDAV via Tailscale Serve HTTPS";
    after = [
      "tailscaled.service"
      "floccus-webdav.service"
    ];
    wants = [ "tailscaled.service" ];
    requires = [ "tailscaled.service" ];
    bindsTo = [ "floccus-webdav.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 --set-path=/floccus http://127.0.0.1:8333";
    };
  };
}
