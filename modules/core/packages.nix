{ pkgs, username, ... }: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fish.enable = true;
    lazygit.enable = true;
    zoxide.enable = true;
    kdeconnect.enable = true;
    firefox.enable = false; # Firefox is not installed by default
    niri = {
      enable = true; # set this so desktop file is created
    };
    hyprland = {
      enable = true; # set this so desktop file is created
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${username}/PolarisOS";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (with pkgs; [
    # essentials
    brightnessctl # light controller
    vim # editor
    tuigreet # greeter
    zip
    unzip
    fish
    git # distributed version control system
    htop # monitors tool
    curl # download tool
    wget # download tool
    tmux
    bleachbit

    #jailbreak
    libimobiledevice
    libusbmuxd
    usbmuxd
    android-tools
  ]);
}
