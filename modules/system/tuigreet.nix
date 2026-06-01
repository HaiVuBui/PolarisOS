{ pkgs
, username
, ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      };
    };
  };

  # greetd is fixed to VT1, the same tty the kernel writes /dev/console to.
  # Silence kernel→console forwarding just before tuigreet takes the tty so
  # late kmsg events don't paint over the TUI. Logs remain in the dmesg buffer.
  systemd.services.greetd.serviceConfig.ExecStartPre =
    "+${pkgs.util-linux}/bin/dmesg --console-off";
}



