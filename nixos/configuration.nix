{
  pkgs,
  userConfig,
  ...
}:
{

  imports = [
    userConfig.hardwareConfig
    ./drivers.nix
  ] ++ (map (path: import path) userConfig.nixModules);

  # ===== Boot Configuration =====

  boot.kernelPackages = pkgs.linuxPackages;

  # disable if switching to grub
  boot.loader.systemd-boot.enable = true;
  #! Enable grub below, note you will have to change to the new bios boot option for settings to apply
  # boot = {
  #   loader = {
  #     efi = {
  #       canTouchEfiVariables = true;
  #       efiSysMountPoint = "/boot/efi";
  #     };
  #     grub = {
  #       enable = true;
  #       devices = [ "nodev" ];
  #       efiSupport = true;
  #       useOSProber = true;
  #     };
  #   };
  # };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.pathsToLink = [
    "/share/icons"
    "/share/themes"
    "/share/fonts"
    "/share/xdg-desktop-portal"
    "/share/applications"
    "/share/mime"
    "/share/wayland-sessions"
    "/share/zsh"
    "/share/bash-completion"
    "/share/fish"
  ];


  # # # ===== Security =====
  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
  };
  security.rtkit.enable = true;

  # ===== System Services =====
  services = {
    libinput.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };
    dbus.enable = true;
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    openssh.enable = true;
    upower.enable = true;
  };

  networking = {
    hostName = userConfig.host;
    networkmanager.enable = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # SSH
      22
    ];
    allowedUDPPorts = [
      # DHCP
      68
      546
    ];
  };

  # ===== System Configuration =====
  time.timeZone = userConfig.timezone;
  i18n.defaultLocale = userConfig.locale;

  # ===== User Configuration =====
  users.users.${userConfig.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    initialPassword = userConfig.defaultPassword;
  };
  users.defaultUserShell = pkgs.zsh;

  # ===== Nix Configuration =====
  nixpkgs.config = {
    allowUnfree = true; 
    permittedInsecurePackages = [
    "openssl-1.1.1w"
    ];
  }
  ;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # ===== Program Configurations =====

  # programs.dconf.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;

  # ===== System Version =====
  system.stateVersion = "25.05"; # Don't change this
}
