{ pkgs, username, ... }:
{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fish.enable = true;
    lazygit.enable = true;
    zoxide.enable = true;
    kdeconnect.enable = true;
    niri = {
      enable = true; # set this so desktop file is created
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${username}/PolarisOS";
    };
  };

  environment.systemPackages = (
    with pkgs;
    [
      # essentials
      # brightnessctl # light controller (laptop only)
      vim # editor
      # tuigreet # greeter (greetd references it by store path)
      zip
      unzip
      # fish # programs.fish.enable
      git # distributed version control system
      htop # monitors tool (btop in home.packages)
      curl # download tool
      wget # download tool
      tmux
      bleachbit

      #jailbreak
      libimobiledevice
      libusbmuxd
      usbmuxd
      android-tools
    ]
  );
}
