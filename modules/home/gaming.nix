{ pkgs, config, lib, osConfig, ... }:
lib.mkIf osConfig.polaris.features.gaming {
  home.packages = with pkgs; [
    umu-launcher
  ];

  home.sessionVariables = {
    WINEDEBUG = "-all";
    DXVK_LOG_LEVEL = "none";
  };

  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      cpu_stats = true;
      gpu_stats = true;
      vram = true;
      ram = true;
      frametime = true;
      frame_timing = true;
      engine_version = true;
      fps_limit = "0,60,120,144";
      toggle_fps_limit = "Shift_R+F1";
    };
  };
}
