{
  description = "PolarisOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    stylix.url = "github:danth/stylix/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    zen-browser = {
          url = "github:0xc000022070/zen-browser-flake";
          inputs.nixpkgs.follows = "nixpkgs"; # keep in sync
        };
    firefox-addons = {                                  # Add-on pkgs
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-flatpak,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "hai";
      lib = nixpkgs.lib;

      hostProfiles = {
        MovingCastle = {
          profile = "default";
          gpuProfiles = [ "intel" ];
        };
        MinasTirith = {
          profile = "default";
          gpuProfiles = [ "nvidia" ];
        };
      };

      mkNixosConfig = { host, profile ? "default", gpuProfile }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username host profile;
        };
        modules = [
          ./profiles/${gpuProfile}
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };

      hostEntries =
        lib.concatMap
          (hostDef:
            let
              cfg = hostDef.cfg;
            in
            map
              (gpuProfile: {
                name = "${hostDef.host}-${gpuProfile}";
                value = mkNixosConfig {
                  inherit gpuProfile;
                  host = hostDef.host;
                  profile = cfg.profile or "default";
                };
              })
              cfg.gpuProfiles)
          (lib.mapAttrsToList (host: cfg: { inherit host cfg; }) hostProfiles);

      nixosConfigurations = lib.listToAttrs hostEntries;
    in
    {
      inherit nixosConfigurations;
    };
}
