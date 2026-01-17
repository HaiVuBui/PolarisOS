{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "momoisay";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "Mon4sm";
    repo = "momoisay";
    rev = "001f4a6";
    sha256 = "sha256-9exrPLoroOiSa6SD6LRjlYo7+uuDTFCbxQcXmLaX2JI";
  };

  buildInputs = [ pkgs.ncurses ];

  buildPhase = ''
    echo "Running build phase..."
    make
  '';

  installPhase = ''
    echo "Running install phase..."
    mkdir -p $out/bin
    cp momoisay $out/bin/
  '';
}

