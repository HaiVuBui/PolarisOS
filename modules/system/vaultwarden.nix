{
  host,
  lib,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) vaultwardenEnable;
in
lib.mkIf vaultwardenEnable {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://minastirith.tail364c4d.ts.net";
      SIGNUPS_ALLOWED = false;
      WEBSOCKET_ENABLED = true;
    };
  };

  systemd.services.vaultwarden-serve = {
    description = "Expose Vaultwarden via Tailscale Serve HTTPS";
    after = [ "tailscaled.service" "vaultwarden.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/tailscale serve --bg --https=443 http://127.0.0.1:8222";
    };
  };
}
