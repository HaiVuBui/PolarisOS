{ pkgs, ... }: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    xz
    libuuid
    icu
    glib
    expat
    libxml2
    libffi
  ];
}

