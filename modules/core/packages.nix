{
  pkgs,
  inputs,
  ...
}:
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
    firefox.enable = false; # Firefox is not installed by default
    niri = {
      enable = true; # set this so desktop file is created
    };
    hyprland = {
      enable = true; # set this so desktop file is created
    };
    dconf.enable = true;
    seahorse.enable = true;
    # fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    # hyprlock.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # essentials
    cliphist # clipboard history
    wl-clipboard # clipboard 
    pavucontrol # audio controller
    pamixer # audi controller
    brightnessctl # light controller
    libnotify # For Notifications
    mako # notifications daemon
    playerctl # media controller
    vim # editor
    tuigreet # greeter

    #dependencies
    ffmpeg
    p7zip
    jq
    poppler
    fzf # command line fuzzy finder
    fd # simple, fast and user-friendly alternative to find
    ripgrep # search tool
    zoxide
    resvg
    imagemagick 
    zip
    unzip
    mpv

    # shells tools
    tmux #window multiplier
    eza # file lister for zsh
    git # distributed version control system
    yazi # cli files manager
    bottom # monitors tool
    nvitop # monitors tool for nvidia
	  tldr # summarize man pages
    htop # monitors tool
    curl # download tool
    wget # download tool
    lazydocker # docker tui
    bluetui # bluetooth tui
    ncdu # disk usage tool

    #jailbreak
    libimobiledevice
    libusbmuxd
    usbmuxd

    # cli funshits
    fastfetch # system information fetch tool
    cava
    cmatrix
    nitch
    lolcat
    figlet
    cowsay
    fortune
    tty-clock
    (pkgs.callPackage ./packages/momoisay.nix {})
  ];
}

