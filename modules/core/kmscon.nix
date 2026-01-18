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
