{ pkgs, inputs, ... }:
{
  # Install Niri and related Wayland utilities
  home.packages = with pkgs; [
    niri
    waybar
    udiskie
    xwayland-satellite
    awww
    inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # default pdf viewer
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "sioyek.desktop" ];
    };
  };

  # Polkit authentication agent — needed for GUI privilege prompts under niri
  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "Polkit GNOME authentication agent";
      BindsTo = "graphical-session.target";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

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
