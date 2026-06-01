{ pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "HaiVuBui";
    repo = "EverCal";
    rev = "6458be10eb25";
    sha256 = "sha256-litR0pzxG3qEFRUiG7G8p/Cquh5Abyv5D6VNst0AsKM";
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
