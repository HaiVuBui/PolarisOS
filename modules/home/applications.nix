{pkgs, ...}: {
  home.packages = with pkgs; [
    # web browsers
    firefox
    librewolf
    # brave

    #terminals
    kitty

    # editors
    sublime

    # AI shits
    gemini-cli
    opencode
    codeium

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

    #shell
    tmux #window multiplier
    eza # file lister for zsh
    oh-my-zsh # plugin manager for zsh
    zsh-powerlevel10k # theme for zsh
    # starship # customizable shell prompt
    git # distributed version control system
    yazi # cli files manager
    bottom # monitors tool
	  tldr
    htop # monitors tool

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


    # UI tools
    waybar
    tofi
    rofi-wayland
    hyprlock
    swww
    wlogout
    udiskie
    xwayland-satellite

    # apps
    obsidian
	  bleachbit
  ];
}


