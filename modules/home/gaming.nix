{ pkgs, config, ... }:
{
  # User-level gaming tooling and defaults.
  # - Lutris for non-Steam titles
  # - Wine (staging, 32/64-bit), Winetricks
  # - Proton management helpers
  # - MangoHud config

  home.packages = with pkgs; [
    lutris
    wineWow64Packages.staging
    winetricks
    protontricks
    protonup-qt
    mangohud
    yad
    zenity
  ];

  # Make it easy for Steam to discover custom Proton builds (via ProtonUp-Qt).
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.local/share/Steam/compatibilitytools.d";
    # Help Lutris web features if Python/requests has trouble finding certs
    SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_DIR = "/etc/ssl/certs";
    # Sensible defaults for Wine/DXVK
    WINEDEBUG = "-all";
    DXVK_LOG_LEVEL = "none";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "${config.xdg.cacheHome}/nv-shaders";
  };

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    # Basic MangoHud overlay suitable for troubleshooting/perf checks.
    fps
    frametime
    cpu_stats
    gpu_stats
    vram
    ram
    io_read
    io_write
    engine_version
    gpu_temp
    cpu_temp
    time
    cpu_power
    gpu_power
    font_size=18
  '';
}
