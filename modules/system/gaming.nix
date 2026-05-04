{ pkgs, ... }:
{
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
        renice = 10;
        softrealtime = "auto";
      };
      cpu.desiredgov = "performance";
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    gamescope
    libstrangle
    vulkan-tools
    dxvk
    vkd3d
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
}
