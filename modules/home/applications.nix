{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # apps
    obsidian
    vesktop
    teams-for-linux
    (pkgs.symlinkJoin {
      name = "sioyek";
      paths = [ pkgs.sioyek ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb
      '';
    })

    # system
    wl-clipboard # clipboard (wl-copy/wl-paste used by scripts + dms watcher)
    libnotify # notify-send, used by scripts/*.sh + archive.nix

    # GUI tools
    rofi # dms spawner
    hyprlock # dms ipc call lock loc
    nautilus

    # terminal ricing
    kitty
    fastfetch # system information fetch tool

    #AI shits
    claude-code

    #dependencies
    ffmpeg
    yt-dlp
    p7zip
    jq
    fzf # command line fuzzy finder
    fd # fuzzy file
    ripgrep # search tool
    poppler # yazi pdf preview
    resvg # yazi svg preview
    mpv
    imv
    nix-output-monitor
    nvd
    wl-clipboard-x11
    wf-recorder
    slurp

    # cli/tui tools
    comma
    eza # file lister for zsh
    yazi # cli files manager
    bluetui # bluetooth tui
    ncdu # disk usage tool
    smartmontools # smartctl (disk health)
    nvitop # monitors tool for nvidia
    tldr # summarize man pages
    lazydocker # docker tui
    systemctl-tui
    lazyjournal
    rclone
    rmpc
    gh
    waypipe
    ookla-speedtest
  ];
  # ++ (with pkgs-unstable; [ ]);
}
