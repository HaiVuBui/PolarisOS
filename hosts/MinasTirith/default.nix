{ ... }:
{
  imports = [
    ./modules/default.nix
    ./hardware.nix
    ./storage.nix
    ../../modules/system/archive.nix
    ../../modules/system/default.nix
  ];
}
