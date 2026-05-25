{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) vaultwardenEnable;
  tailscale = "${pkgs.tailscale}/bin/tailscale";
  waitForTailscale = "${pkgs.bash}/bin/bash -c 'for i in {1..30}; do ${tailscale} status --self=true --peers=false >/dev/null 2>&1 && exit 0; sleep 1; done; exit 1'";
in
lib.mkIf vaultwardenEnable {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://minastirith.tail364c4d.ts.net/vaultwarden";
      SIGNUPS_ALLOWED = false;
      WEBSOCKET_ENABLED = true;
    };
  };

  systemd.services.vaultwarden-serve = {
    description = "Expose Vaultwarden via Tailscale Serve HTTPS";
    after = [ "tailscaled.service" "vaultwarden.service" ];
    requires = [ "tailscaled.service" ];
    bindsTo = [ "vaultwarden.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = waitForTailscale;
      ExecStart = "${tailscale} serve --bg --https=443 --set-path=/vaultwarden http://127.0.0.1:8222/vaultwarden";
    };
  };
}
