{pkgs, ... }:

{
  # Enable TLP
  services.tlp = {
    enable = true;
    settings = {
      # CPU settings: Maximize performance
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance"; # Optional, for systems with battery
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;
      CPU_BOOST_ON_AC = 1; # Enable CPU boost
      CPU_BOOST_ON_BAT = 1;
      SCHED_POWERSAVE_ON_AC = 0; # Disable scheduler power saving
      SCHED_POWERSAVE_ON_BAT = 0;

      # Disk settings: Disable power-saving features
      DISK_IDLE_SECS_ON_AC = 0; # Disable disk spin-down
      DISK_IDLE_SECS_ON_BAT = 0;
      DISK_APM_LEVEL_ON_AC = "255"; # Maximum performance (disable APM)
      DISK_APM_LEVEL_ON_BAT = "255";
      SATA_LINKPWR_ON_AC = "max_performance"; # Maximize SATA link performance
      SATA_LINKPWR_ON_BAT = "max_performance";
      AHCI_RUNTIME_PM_ON_AC = "off"; # Disable runtime power management
      AHCI_RUNTIME_PM_ON_BAT = "off";

      # Runtime power management for devices
      RUNTIME_PM_ON_AC = "off"; # Disable runtime PM for devices
      RUNTIME_PM_ON_BAT = "off";

      # PCIe Active State Power Management
      PCIE_ASPM_ON_AC = "performance"; # Disable PCIe power saving
      PCIE_ASPM_ON_BAT = "performance";

      # USB settings
      USB_AUTOSUSPEND = 0; # Disable USB autosuspend
      USB_BLACKLIST_WWAN = 1; # Blacklist WWAN devices from autosuspend

      # Network settings
      WIFI_PWR_ON_AC = 0; # Disable WiFi power saving
      WIFI_PWR_ON_BAT = 0;

      # Sound power saving
      SOUND_POWER_SAVE_ON_AC = 0; # Disable sound power saving
      SOUND_POWER_SAVE_ON_BAT = 0;
      SOUND_POWER_SAVE_CONTROLLER = "N";

      # Other performance settings
      NMI_WATCHDOG = 0; # Disable NMI watchdog for lower latency
      TLP_DEFAULT_MODE = "AC"; # Always use AC mode (performance)
      TLP_PERSISTENT_DEFAULT = 1; # Ensure settings persist
    };
  };

  # Optional: Enable power-profiles-daemon to avoid conflicts
  services.power-profiles-daemon.enable = false;

  # Optional: Ensure performance governor is set system-wide
  powerManagement.cpuFreqGovernor = "performance";

  # Enable necessary kernel modules for performance
  boot.kernelModules = [ "cpufreq_performance" ];

  # Ensure TLP package is installed
  environment.systemPackages = with pkgs; [ tlp ];
}
