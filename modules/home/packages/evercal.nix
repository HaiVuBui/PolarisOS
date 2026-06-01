{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "HaiVuBui";
    repo = "EverCal";
    rev = "33c91b20d3c5";
    sha256 = "sha256-KoUqEaZA639BdDwbjBod6FLneDGbiTg5QZAZV7/hZ68";
  };
in
pkgs.flutter.buildFlutterApplication rec {
  pname = "evercal";
  version = "1.0.0";

  inherit src;

  autoPubspecLock = "${src}/pubspec.lock";

  # Upstream binary is named "ever_cal"; provide a stable "evercal" alias.
  postInstall = ''
    ln -s $out/bin/ever_cal $out/bin/evercal
  '';
}
