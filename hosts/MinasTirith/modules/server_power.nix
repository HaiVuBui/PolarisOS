{ pkgs, ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
      CPU_MIN_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 100;
      CPU_MAX_PERF_ON_BAT = 100;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 0;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "performance";

      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 0;
      DISK_APM_LEVEL_ON_AC = "255";
      DISK_APM_LEVEL_ON_BAT = "255";
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "max_performance";
      AHCI_RUNTIME_PM_ON_AC = "off";
      AHCI_RUNTIME_PM_ON_BAT = "off";

      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "performance";
      RUNTIME_PM_ON_AC = "off";
      RUNTIME_PM_ON_BAT = "off";
      USB_AUTOSUSPEND = 0;
      WIFI_PWR_ON_AC = 0;
      WIFI_PWR_ON_BAT = 0;
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 0;
      SOUND_POWER_SAVE_CONTROLLER = "N";

      TLP_DEFAULT_MODE = "AC";
      TLP_PERSISTENT_DEFAULT = 1;
    };
  };

  services.power-profiles-daemon.enable = false;
  powerManagement.cpuFreqGovernor = "performance";
  environment.systemPackages = with pkgs; [ tlp ];
}
