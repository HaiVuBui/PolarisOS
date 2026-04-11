{ ... }:
{
  imports = [
    ./modules/default.nix
    ./hardware.nix
    ./storage.nix
    ../../modules/system/default.nix
    # ../../modules/system/gaming.nix
  ];
}
