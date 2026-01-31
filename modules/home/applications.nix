{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs;
    [
      # apps
      obsidian
      firefox

      # system
      cliphist # clipboard history
      wl-clipboard # clipboard
      pavucontrol # audio controller
      brightnessctl # light controller
      libnotify # For Notifications
      mako # notifications daemon
      playerctl # media controller
      tuigreet # greeter
      bluetui # bluetooth tui
      ncdu # disk usage tool
      wiremix # audio mixer
      xwayland-satellite
      udiskie

      # AI shits
      gemini-cli
      opencode
      codeium

      # GUI tools
      waybar
      tofi
      rofi
      hyprlock
      swww
      # wlogout
      kdePackages.dolphin
      (pkgs.callPackage ./packages/evercal.nix { inherit pkgs; }) # calendar

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
      rmpc
      khal 
      aerc
    ] ++ (with pkgs-unstable; [ codex ]);
}

