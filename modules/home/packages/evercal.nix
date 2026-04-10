{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "snes19xx";
    repo = "EverCal";
    rev = "faecbf5";
    sha256 = "sha256-gXbv6Vq954TBKAnzygzfNBfuFuRqWdX/jDa+PJOjG1s";
  };
in pkgs.flutter.buildFlutterApplication rec {
  pname = "evercal";
  version = "1.0.0";

  inherit src;

  autoPubspecLock = "${src}/pubspec.lock";

  # Upstream binary is named "ever_cal"; provide a stable "evercal" alias.
  postInstall = ''
    ln -s $out/bin/ever_cal $out/bin/evercal
  '';
}
