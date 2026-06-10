{ pkgs, config, lib, osConfig, ... }:
lib.mkIf osConfig.polaris.features.gaming {
  home.packages = with pkgs; [
    umu-launcher
  ];

  home.sessionVariables = {
    WINEDEBUG = "-all";
    WINEESYNC = "1";
    WINEFSYNC = "1";
    DXVK_LOG_LEVEL = "none";
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SIZE = "10737418240";
    __GL_SHADER_DISK_CACHE_PATH = "${config.xdg.cacheHome}/nv-shaders";
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
