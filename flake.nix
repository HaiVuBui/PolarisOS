{
  description = "PolarisOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    niri-scratchpad.url = "github:argosnothing/niri-scratchpad-rs";
  };

  outputs =
    { nixpkgs, nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "hai";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (
            final: prev:
            lib.optionalAttrs prev.stdenv.hostPlatform.isi686 {
              openldap = prev.openldap.overrideAttrs (_: {
                doCheck = false;
              });
            }
          )
        ];
      };

      mkNixosConfig =
        { host }:
        lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs username host; };
          modules = [
            ./hosts/${host}
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

      hosts = [
        "MovingCastle"
        "MinasTirith"
      ];

      nixosConfigurations = lib.genAttrs hosts (host: mkNixosConfig { inherit host; });
    in
    {
      inherit nixosConfigurations;

      devShells.${system}.gpu = pkgs.mkShell {
        packages = with pkgs; [ cudatoolkit ];
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:/run/opengl-driver/lib:$LD_LIBRARY_PATH"
        '';
      };
    };
}
