{ pkgs, pkgs-unstable, inputs, username, host, ... }:
let inherit (import ../../hosts/${host}/variables.nix) gitUsername;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username host pkgs-unstable; };
    users.${username} = {
      imports = [
        ./../home/default.nix
        inputs.nix-index-database.homeModules.nix-index
      ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "adbusers"
      "docker" # access to docker as non-root
      "libvirtd" # Virt manager/QEMU access
      "lp"
      "networkmanager"
      "scanner"
      "wheel" # subdo access
      "vboxusers" # Virtual Box
      "podman"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
