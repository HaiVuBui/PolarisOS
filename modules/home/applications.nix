{pkgs, ...}: {
  home.packages = with pkgs; [
    # web browsers
    firefox

    #terminals
    kitty

    # AI shits
    gemini-cli
    opencode
    codeium

    #shell
    oh-my-zsh # plugin manager for zsh
    zsh-powerlevel10k # theme for zsh

    # UI tools
    waybar
    nautilus
    tofi
    rofi
    hyprlock
    swww
    wlogout
    udiskie
    xwayland-satellite

    # mucis
    rmpc
    yt-dlp

    # apps
    obsidian
	  bleachbit
  ];
}


