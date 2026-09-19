{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia-container-toolkit.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # 1080 Ti ships at 250 W of a 350 W ceiling; more headroom holds boost clocks longer
  systemd.services.nvidia-power-limit = {
    description = "Raise NVIDIA GPU power limit";
    after = [ "nvidia-persistenced.service" ];
    wants = [ "nvidia-persistenced.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi --power-limit=300";
    };
  };
  boot.kernelModules = [
    "nvidia"
    "nvidia_uvm"
    "nvidia_drm"
    "nvidia_modeset"
  ];
}
