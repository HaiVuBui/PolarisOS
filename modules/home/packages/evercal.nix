{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "HaiVuBui";
    repo = "EverCal";
    rev = "e97c903";
    sha256 = "sha256-J/VaBZGWa5aLg1ObFtgLJNVk1wiAgJ0Mj1JMgL+n4Is";
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
