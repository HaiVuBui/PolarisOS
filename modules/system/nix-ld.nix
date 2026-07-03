{ pkgs, ... }: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
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
    libxcrypt-legacy
  ];
}

