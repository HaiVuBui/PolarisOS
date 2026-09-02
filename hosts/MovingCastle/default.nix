{ ... }:
{
  imports = [
    ./modules/default.nix
    ./hardware.nix
    ../../modules/system/default.nix
  ];

  polaris = {
    git.username = "HaiVuBui";
    git.email = "buivuhai1105@gmail.com";
    displayManager = "tui";
    network = "iwd";
    cores = 4;
    nopasswdSudo = true;
    stylixImage = ../../wallpapers/angel-warior.jpg;
    features = {
      cuda = false;
      gaming = false;
      jellyfin = false;
      vaultwarden = false;
      archive = false;
    };
  };
}
