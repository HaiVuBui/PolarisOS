{
  description = "PolarisOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs"; # keep in sync
    };
    firefox-addons = { # Add-on pkgs
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "hai";
      lib = nixpkgs.lib;

      mkNixosConfig = { host }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs username host;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/${host}
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

      hosts = [ "MovingCastle" "MinasTirith" ];

      nixosConfigurations = lib.genAttrs hosts (host: mkNixosConfig { inherit host; });
    in { inherit nixosConfigurations; };
}
