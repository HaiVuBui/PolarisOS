{ config, lib, pkgs, ... }:
lib.mkIf config.polaris.features.gaming {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.uinput.enable = true;
  hardware.steam-hardware.enable = true;

  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        desiredgov = "performance";
        renice = 10;
        softrealtime = "auto";
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1;
      };
    };
  };

  services.irqbalance.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.oomd.enable = true;

  # NTSYNC — kernel-side Wine sync primitives, replaces esync/fsync
  boot.kernelModules = [ "ntsync" ];

  environment.systemPackages = with pkgs; [
    lutris
    winetricks
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    # Suppress kcompactd wakeups that cause micro-stutter in long sessions
    "vm.compaction_proactiveness" = 0;
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "524288"; }
    { domain = "*"; type = "hard"; item = "nofile"; value = "524288"; }
  ];

}
