{ pkgs, ... }:
{
  programs.ccache.enable = true;
  environment.systemPackages = with pkgs; [
    # --core--
    # toolchain
    gcc
    binutils
    gnumake

    # build tools
    cmake
    ninja

    # --- dependencies management---
    pkg-config # find libs in the environment

    # auto tools
    autoconf
    automake
    libtool

    ## doc
    man-pages
    man-pages-posix
  ];
}
