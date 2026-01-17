{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "snes19xx";
    repo = "EverCal";
    rev = "39561a1";
    sha256 = "sha256-FuHotjs3spnWE5wM+C5My/5KuzjThIC1QbNMx6wH0R0=";
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
