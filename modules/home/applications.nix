{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # apps
    obsidian
    anydesk
    firefox
    vesktop
    teams-for-linux
    zed-editor
    qbittorrent
    zathura
    (pkgs.symlinkJoin {
      name = "sioyek";
      paths = [ pkgs.sioyek ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb
      '';
    })
    foliate

    # system
    cliphist # clipboard history
    wl-clipboard # clipboard
    pavucontrol # audio controller
    brightnessctl # light controller
    libnotify # For Notifications
    swaynotificationcenter # notification daemon + center (history)
    playerctl # media controller
    pamixer
    tuigreet # greeter
    bluetui # bluetooth tui
    ncdu # disk usage tool
    smartmontools # smartctl (disk health)
    wiremix # audio mixer
    xwayland-satellite
    udiskie

    # GUI tools
    waybar
    tofi
    rofi
    hyprlock
    # wlogout
    kdePackages.dolphin
    inputs.evercal.packages.${pkgs.stdenv.hostPlatform.system}.default # calendar
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    nautilus

    # terminal ricing
    kitty
    fastfetch # system information fetch tool
    cava
    cmatrix
    nitch
    lolcat
    figlet
    cowsay
    fortune
    tty-clock
    (pkgs.callPackage ./packages/momoisay.nix { inherit pkgs; })

    #AI shits
    codex
    gemini-cli
    opencode
    codeium
    claude-code
    rtk # token-killer CLI proxy
    mcp-server-fetch
    mcp-server-time

    #dependencies
    ffmpeg
    yt-dlp
    p7zip
    jq
    fzf # command line fuzzy finder
    fd # fuzzy file
    ripgrep # search tool
    poppler
    zoxide
    resvg
    mpv
    nix-output-monitor
    nvd
    imagemagick
    w3m
    pandoc
    markdown-oxide
    wl-clipboard-x11
    wf-recorder
    slurp

    # cli/tui tools
    comma
    eza # file lister for zsh
    yazi # cli files manager
    bottom # monitors tool
    nvitop # monitors tool for nvidia
    tldr # summarize man pages
    htop # monitors tool
    btop # robust monitors
    curl # download tool
    wget # download tool
    lazydocker # docker tui
    systemctl-tui
    lazyjournal
    zk
    rclone
    rmpc
    khal
    aerc
    magic-wormhole
    gh
    calibre
  ];
  # ++ (with pkgs-unstable; [ ]);
}
