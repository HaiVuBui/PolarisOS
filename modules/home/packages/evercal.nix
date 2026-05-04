{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "HaiVuBui";
    repo = "EverCal";
    rev = "deeb11b87d17";
    sha256 = "sha256-yX6P5dvAJgLPkbxx2TQTYyMkXm+aIobYrSN6/QWS710";
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
