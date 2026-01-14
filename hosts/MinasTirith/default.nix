{ ... }: {
  imports = [
    ./modules/default.nix
    ./hardware.nix
    ./storage.nix
    ../../modules/core/default.nix
    ../../modules/core/gaming.nix
  ];
}
