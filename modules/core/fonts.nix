{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # dejavu_fonts
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code

      jetbrains-mono
      nerd-fonts.jetbrains-mono

      nerd-fonts.symbols-only

      font-awesome
      hackgen-nf-font
      ibm-plex
      inter
      material-icons
      maple-mono.NF
      minecraftia
      nerd-fonts.im-writing
      nerd-fonts.blex-mono
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-monochrome-emoji
      powerline-fonts
      roboto
      roboto-mono
      symbola
      terminus_font
    ];
  };
}
