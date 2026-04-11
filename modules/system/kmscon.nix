{ config, pkgs, lib, ... }:
let
  cfg = config.services.kmscon;
  # Add bitmap engine when GPU rendering is enabled to keep glyphs sharp
  extraOpts =
    lib.concatStringsSep " " (
      [ "--term=xterm-256color" ]
      ++ lib.optional cfg.hwRender "--font-engine=8x16"
    );
  fontSize = if cfg.hwRender then "16" else "14";
in
{
  console = {
    colors = [
      "272e33"
      "e67e80"
      "a7c080"
      "dbbc7f"
      "7fbbb3"
      "d699b6"
      "83c092"
      "d3c6aa"
      "7a8478"
      "e69875"
      "a7c080"
      "dbbc7f"
      "7fbbb3"
      "d699b6"
      "83c092"
      "d3c6aa"
    ];
  };

  services.kmscon = {
    enable = true;
    extraConfig = ''
      # Match DPI for 1080p panels so glyphs stay sharp
      font-dpi=96
      # Slightly larger font to keep strokes readable on most panels
      font-size=${fontSize}
      ${lib.optionalString cfg.hwRender "font-engine=8x16"}
      # Everforest palette to match the themed console colors.
      palette=custom
      palette-black=39, 46, 51
      palette-red=230, 126, 128
      palette-green=167, 192, 128
      palette-yellow=219, 188, 127
      palette-blue=127, 187, 179
      palette-magenta=214, 153, 182
      palette-cyan=131, 192, 146
      palette-light-grey=211, 198, 170
      palette-dark-grey=122, 132, 120
      palette-light-red=230, 152, 117
      palette-light-green=167, 192, 128
      palette-light-yellow=219, 188, 127
      palette-light-blue=127, 187, 179
      palette-light-magenta=214, 153, 182
      palette-light-cyan=131, 192, 146
      palette-white=211, 198, 170
      palette-foreground=211, 198, 170
      palette-background=39, 46, 51
    '';

    # Advertise 256-color support; add bitmap engine when GPU is on to avoid blur
    extraOptions = extraOpts;

    fonts = [
      {
        name = "JetBrainsMono Nerd Font Mono";
        package = pkgs.nerd-fonts.jetbrains-mono;
      }
      {
        name = "Noto Sans Mono";
        package = pkgs.noto-fonts;
      }
    ];

    # CPU rendering keeps text crisp; override to true per-host if desired
    hwRender = lib.mkDefault false;
    # Reuse XKB layout/options so TTY matches the DE keymap
    useXkbConfig = true;
  };
}
