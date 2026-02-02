{ pkgs, ... }: {
  # Install Niri and related Wayland utilities
  home.packages = with pkgs; [ niri waybar udiskie xwayland-satellite swww ];

  # Note: Niri config is managed at ~/.config/niri/config.kdl
  # Remove the xdg.configFile line to allow manual configuration

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

