{ pkgs, ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      CPU_MIN_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 0;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      DISK_APM_LEVEL_ON_AC = "255 255";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
      AHCI_RUNTIME_PM_ON_AC = "off";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_AC = "off";
      RUNTIME_PM_ON_BAT = "auto";

      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_WWAN = 1;

      WIFI_PWR_ON_AC = 0;
      WIFI_PWR_ON_BAT = 1;

      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  services.power-profiles-daemon.enable = false;

  environment.systemPackages = with pkgs; [ tlp ];
}
