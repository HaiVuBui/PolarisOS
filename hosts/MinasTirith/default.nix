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
    cores = 6;
    nopasswdSudo = true;
    stylixImage = ../../wallpapers/angel-warior.jpg;
    features = {
      cuda = true;
      gaming = true;
      jellyfin = true;
      vaultwarden = true;
      floccus = true;
      archive = true;
    };
  };
}
