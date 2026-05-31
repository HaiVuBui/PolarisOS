{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # --- The Big Three (Your Defaults) ---
      nerd-fonts.jetbrains-mono  # Main Terminal/Code font
      inter                      # Main UI/Sans font
      noto-fonts                 # Main Serif/Book font

      # --- Icons & Symbols ---
      nerd-fonts.symbols-only    # The "Glue" that fixes missing icons
      font-awesome               # Common backup for Polybar/Waybar icons

      # --- Language & Emoji Support (Essential) ---
      noto-fonts-color-emoji     # Standard colored emojis
      noto-fonts-cjk-sans        # Asian characters (Japanese/Chinese/Korean)
      noto-fonts-cjk-serif       # Asian characters (Serif variant)
    ];
  };

  fonts.fontconfig = {
  enable = true;
  defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font Mono" ];
    serif = [ "Noto Serif" ];
    sansSerif = [ "Inter" ];
  };
};
}
