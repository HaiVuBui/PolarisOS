{ pkgs, lib, host, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
  steamEnable = (vars.steamEnable or false);
in
{
  # Core gaming stack suitable for NVIDIA on Wayland (Niri/Hyprland) and X11.
  # - Optional Steam client (off by default; toggle via hosts/<host>/variables.nix: steamEnable = true;)
  # - Enables Feral GameMode
  # - Adds controller/USB rules via steam-hardware
  # - Ensures 32-bit graphics for Wine/Proton
  # - Installs useful tools: Gamescope, MangoHud, Vulkan tools

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

  programs.steam = lib.mkIf steamEnable {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Provide gamescope wrapper with needed capabilities
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    gamescope
    mangohud
    vulkan-tools
    cabextract # needed by winetricks to extract MS cab files
    p7zip
    unzip
    dxvk
    vkd3d
  ];
}
