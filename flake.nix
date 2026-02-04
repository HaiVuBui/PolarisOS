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
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs"; # keep in sync
    # };
    # firefox-addons = { # Add-on pkgs
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { nixpkgs,  nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "hai";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      # pkgs-unstable = import nixpkgs-unstable {
      #   inherit system;
      #   config.allowUnfree = true;
      # };

      mkNixosConfig = { host }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username host; };
          modules = [ ./hosts/${host} nix-flatpak.nixosModules.nix-flatpak ];
        };

      hosts = [ "MovingCastle" "MinasTirith" ];

      nixosConfigurations =
        lib.genAttrs hosts (host: mkNixosConfig { inherit host; });
    in {
      inherit nixosConfigurations;

      devShells.${system}.gpu = pkgs.mkShell {
        packages = with pkgs; [ cudatoolkit ];
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:/run/opengl-driver/lib:$LD_LIBRARY_PATH"
        '';
      };
    };
}
