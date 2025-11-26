{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = true;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg {
    # OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
