{ pkgs, ... }: {
  systemd.user.services.vdirsyncer = {
    Unit = {
      Description = "Sync calendars and contacts";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      # Ensure vdirsyncer is in your path or point to it directly
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
      # Optional: Reduced CPU priority
      Nice = 19;
      CPUSchedulingPolicy = "idle";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  systemd.user.timers.vdirsyncer = {
    Unit = { Description = "Sync calendars and contacts periodically"; };
    Timer = {
      # Run 5 minutes after boot
      OnBootSec = "5m";
      # Run every 15 minutes thereafter
      OnUnitActiveSec = "15m";
      Unit = "vdirsyncer.service";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  home.packages = with pkgs; [ vdirsyncer ];
}
