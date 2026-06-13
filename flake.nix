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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    evercal = {
      url = "github:HaiVuBui/EverCal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-scratchpad.url = "github:argosnothing/niri-scratchpad-rs";
    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    helium.url = "github:oxcl/nix-flake-helium-browser";
    # Driver for the 06cb:009a fingerprint sensor on MovingCastle. Pins its own
    # nixos-24.11 nixpkgs on purpose — the python-validity package does not build
    # against unstable, which upstream explicitly does not support.
    fingerprint-06cb-009a.url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor?ref=24.11";
  };

  outputs =
    {
      nixpkgs,
      nix-gaming,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "hai";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkNixosConfig =
        { host }:
        lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs username host; };
          modules = [
            ./hosts/${host}
            inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
            nix-gaming.nixosModules.pipewireLowLatency
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
    };
}
