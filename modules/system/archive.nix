{ config, lib, pkgs, username, ... }:
lib.mkIf config.polaris.features.archive {
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
      pkgs.gnused
      pkgs.libnotify
      pkgs.rclone
      pkgs.util-linux
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "archive-maintenance" ''
        set -eu

        uid=$(id -u ${username})

        notify() {
          runuser -u ${username} -- env \
            XDG_RUNTIME_DIR=/run/user/$uid \
            DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus \
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

        if ! runuser -u ${username} -- rclone check --download "$snapshot" secret:/Archive; then
          notify "rclone check failed or mismatched, see log"
          exit 1
        fi

        # Keep 12 months, then one per year. The archive-* glob matters:
        # /snapshots also holds the ARCHIVE, SNAPSHOTS and STORAGE subvolumes.
        cutoff=$(date -d "12 months ago" +%Y%m%d)
        pruned=0
        kept=0
        years=""

        for snap in $(printf '%s\n' /snapshots/archive-* | sort -r); do
          [ -d "$snap" ] || continue

          kept=$((kept + 1))
          if [ "$kept" -le 3 ]; then
            continue
          fi

          stamp=$(basename "$snap" \
            | sed -nE 's/^archive-([0-9]{4})-([0-9]{2})-([0-9]{2})_.*/\1\2\3/p')
          [ -n "$stamp" ] || continue

          year=''${stamp%????}

          if [ "$stamp" -ge "$cutoff" ]; then
            case " $years " in *" $year "*) ;; *) years="$years $year" ;; esac
            continue
          fi

          # Newest first, so the first survivor of a year is the one kept.
          case " $years " in
            *" $year "*)
              if btrfs subvolume delete "$snap"; then
                pruned=$((pruned + 1))
              fi
              ;;
            *)
              years="$years $year"
              ;;
          esac
        done

        if [ "$pruned" -gt 0 ]; then
          notify "Archive is safe. Pruned $pruned old snapshots."
        else
          notify "Archive is safe"
        fi
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
