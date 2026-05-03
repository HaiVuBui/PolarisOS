{ pkgs, ... }:
{
  systemd.services.archive-maintenance = {
    description = "Archive checker";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    unitConfig = {
      RequiresMountsFor = [
        "/Archive"
        "/snapshots"
      ];
    };

    path = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.libnotify
      pkgs.rclone
      pkgs.util-linux
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "archive-maintenance" ''
        set -eu

        notify() {
          runuser -u hai -- env \
            XDG_RUNTIME_DIR=/run/user/1000 \
            DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
            notify-send "Archive maintenance finished" "$1" || true
        }

        if ! btrfs scrub start -B /Archive; then
          notify "scrub could not finish"
          exit 1
        fi

        if ! btrfs scrub status /Archive | grep -q "Error summary:.*no errors found"; then
          notify "IO errors found, see log"
          exit 1
        fi

        snapshot="/snapshots/archive-$(date +%Y-%m-%d_%H-%M-%S)"

        if ! btrfs subvolume snapshot -r /Archive "$snapshot"; then
          notify "snapshot failed, see log"
          exit 1
        fi

        if ! runuser -u hai -- rclone check --download "$snapshot" secret:/Archive; then
          notify "rclone check failed or mismatched, see log"
          exit 1
        fi

        notify "Archive is safe"
      ''}";
    };
  };

  systemd.timers.archive-maintenance = {
    description = "Monthly /Archive healthcheck";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
  };
}
