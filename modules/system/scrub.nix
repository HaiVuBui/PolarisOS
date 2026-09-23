{ config, lib, pkgs, username, ... }:
let
  # One entry per filesystem, not per mountpoint: scrub works on the whole
  # filesystem, so /Archive covers /snapshots too, and / covers /nix and /home.
  # archive-maintenance also scrubs /Archive monthly; the overlap is harmless.
  targets = [ "/" "/Storage" "/Archive" ];
in
lib.mkIf config.polaris.features.scrub {
  systemd.services.btrfs-scrub = {
    description = "Btrfs scrub of the system and storage filesystems";

    unitConfig.RequiresMountsFor = targets;

    path = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.curl
      pkgs.gnugrep
      pkgs.gnused
      pkgs.jq
      pkgs.libnotify
      pkgs.util-linux
    ];

    serviceConfig = {
      Type = "oneshot";
      StateDirectory = "btrfs-scrub";
      # Scrub saturates the disk; stay out of the way of anything interactive.
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";
      ExecStart = "${pkgs.writeShellScript "btrfs-scrub" ''
        set -euo pipefail

        state=/var/lib/btrfs-scrub
        report=$state/report.md
        errors=$state/errors.txt
        model=${lib.escapeShellArg config.polaris.logModel}

        : > "$errors"
        : > "$state/summary.txt"

        for fs in ${lib.concatStringsSep " " (map lib.escapeShellArg targets)}; do
          # -B runs in the foreground, so this blocks until the scrub is done.
          # A nonzero exit means errors were found, which the status below
          # reports properly, so it is not fatal here.
          btrfs scrub start -B "$fs" >/dev/null 2>&1 || true
          status=$(btrfs scrub status "$fs" 2>&1)

          printf '%s\n%s\n\n' "=== $fs" "$status" >> "$state/summary.txt"

          # "Error summary: no errors found" is the clean case; anything else
          # names the errors it found.
          if ! printf '%s' "$status" | grep -q "Error summary:.*no errors found"; then
            printf '%s\n%s\n\n' "=== $fs" "$status" >> "$errors"
          fi
        done



        uid=$(id -u ${username})
        notify() {
          runuser -u ${username} -- env \
            XDG_RUNTIME_DIR=/run/user/$uid \
            DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus \
            notify-send "Btrfs scrub" "$1" || true
        }

        # Clean scrubs need no interpretation; only a real error is worth
        # spending the model on.
        if [ ! -s "$errors" ]; then
          {
            echo "Scrub clean. No errors on ${lib.concatStringsSep ", " targets}."
            echo
            cat "$state/summary.txt"
          } > "$report"
          notify "Clean. No errors found."
          exit 0
        fi

        {
          echo "SCRUB FOUND ERRORS"
          echo
          cat "$errors"
          echo "---"
        } > "$report"

        if jq -n \
             --arg model "$model" \
             --rawfile errors "$errors" \
             '{
               model: $model,
               stream: false,
               think: false,
               options: { temperature: 0, num_ctx: 8192 },
               prompt: (
                 "btrfs scrub results from a NixOS workstation. Data is stored "
                 + "single profile and metadata DUP, so metadata errors can be "
                 + "repaired from the second copy but data errors cannot.\n\n"
                 + $errors
                 + "\n---\n"
                 + "Explain what these numbers mean in plain terms: which "
                 + "filesystem is affected, whether the errors were corrected, "
                 + "and whether this points at failing hardware or at "
                 + "recoverable corruption. Do not recommend commands. Say "
                 + "plainly when you do not know.\n"
               )
             }' \
             | curl -sSf --max-time 3600 --data-binary @- \
                 http://127.0.0.1:11434/api/generate \
             | jq -r '.response' >> "$report"
        then :; else
          echo "(model unavailable; raw scrub output above)" >> "$report"
        fi

        notify "ERRORS FOUND. See $report"
      ''}";
    };
  };

  systemd.timers.btrfs-scrub = {
    description = "Weekly btrfs scrub";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      RandomizedDelaySec = "6h";
      Persistent = true;
    };
  };
}
