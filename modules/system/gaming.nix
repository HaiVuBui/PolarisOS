{ pkgs, ... }:
{
  # Core gaming stack suitable for NVIDIA on Wayland (Niri/Hyprland) and X11.
  # - Enables Feral GameMode
  # - Adds controller/USB rules via steam-hardware
  # - Ensures 32-bit graphics for Wine/Proton
  # - Installs useful tools: Gamescope, Vulkan tools

  hardware.graphics.enable32Bit = true;

  hardware.steam-hardware.enable = true;

  # Allow user input emulation (some controllers / Steam Input / DS4/DS5)
  hardware.uinput.enable = true;

  # Extra community udev rules for gamepads, wheels, etc.
  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 10;
    };
  };

  # Provide gamescope wrapper with needed capabilities
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    gamescope
    vulkan-tools
    dxvk
    vkd3d
  ];
}
