{ pkgs, inputs, ... }:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };

  # Install Niri and related Wayland utilities
  home.packages = with pkgs; [
    niri
    # waybar
    udiskie
    xwayland-satellite
    # awww
    inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Enable XWayland satellite for X11 app support
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside Wayland";
      BindsTo = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "journal";
      Restart = "on-failure";
    };
  };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    OZONE_PLATFORM = "wayland";
  };
}
