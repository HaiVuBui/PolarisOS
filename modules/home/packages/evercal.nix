{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "HaiVuBui";
    repo = "EverCal";
    rev = "31d89db53f63";
    sha256 = "sha256-lYarES3jGgnh81D/A9Fbo680aj4haaQxbbHPuE3DLvs";
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
