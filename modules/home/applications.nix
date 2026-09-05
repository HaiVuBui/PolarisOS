{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # apps
    # obsidian
    # anydesk
    # firefox
    # vesktop
    # teams-for-linux
    # zed-editor
    # antigravity-ide
    # qbittorrent
    # zathura
    # (pkgs.symlinkJoin {
    #   name = "sioyek";
    #   paths = [ pkgs.sioyek ];
    #   nativeBuildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     wrapProgram $out/bin/sioyek \
    #       --set QT_QPA_PLATFORM xcb
    #   '';
    # })
    # foliate

    # system
    # cliphist # clipboard history (dms has its own store)
    wl-clipboard # clipboard (wl-copy/wl-paste used by scripts + dms watcher)
    # brightnessctl # light controller (laptop only)
    libnotify # notify-send, used by scripts/*.sh + archive.nix
    # swaynotificationcenter # notification daemon (dms is the daemon now)
    # pavucontrol / pamixer / playerctl / wiremix # dms handles audio + mpris
    # tuigreet # greeter (greetd references it by store path)
    # xwayland-satellite / udiskie # installed by niri.nix

    # GUI tools
    # waybar
    # tofi
    # rofi # dms spawner
    # hyprlock # dms ipc call lock lock
    # wlogout
    # kdePackages.dolphin
    # inputs.evercal.packages.${pkgs.stdenv.hostPlatform.system}.default # calendar
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    # nautilus

    # terminal ricing
    kitty
    fastfetch # system information fetch tool
    # cava
    # cmatrix
    # nitch
    # lolcat
    # figlet
    # cowsay
    # fortune
    # tty-clock
    # (pkgs.callPackage ./packages/momoisay.nix { inherit pkgs; })

    #AI shits
    # codex
    # opencode
    # codeium
    # claude-code

    #dependencies
    ffmpeg
    yt-dlp
    p7zip
    jq
    fzf # command line fuzzy finder
    fd # fuzzy file
    ripgrep # search tool
    # poppler # yazi pdf preview
    # zoxide # programs.zoxide.enable
    # resvg # yazi svg preview
    mpv
    imv
    nix-output-monitor
    nvd
    # imagemagick # yazi image preview
    # w3m
    # pandoc
    # markdown-oxide
    wl-clipboard-x11
    # wf-recorder
    slurp

    # cli/tui tools
    comma
    eza # file lister for zsh
    yazi # cli files manager
    bluetui # bluetooth tui
    ncdu # disk usage tool
    smartmontools # smartctl (disk health)
    # bottom # monitors tool
    nvitop # monitors tool for nvidia
    tldr # summarize man pages
    # htop # monitors tool
    # btop # robust monitors
    # curl # download tool (systemPackages)
    # wget # download tool (systemPackages)
    lazydocker # docker tui
    systemctl-tui
    lazyjournal
    # zk
    rclone
    rmpc
    # khal
    # aerc
    # magic-wormhole
    gh
    # calibre
    waypipe
    # xhost
    ookla-speedtest
  ];
  # ++ (with pkgs-unstable; [ ]);
}
