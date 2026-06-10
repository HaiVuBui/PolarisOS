{
  config,
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports = [
        ./../home/default.nix
        inputs.nix-index-database.homeModules.nix-index
      ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
        enableNixpkgsReleaseCheck = false;
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = config.polaris.git.username;
    extraGroups = [
      "adbusers"
      "docker" # access to docker as non-root
      "gamemode" # allow GameMode priority optimizations
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
    linger = true;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
