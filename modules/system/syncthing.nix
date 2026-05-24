{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "hai"; # REPLACE with your actual username
    dataDir = "/home/hai"; # Default folder for new synced directories
    configDir = "/home/hai/.config/syncthing"; # Folder for Syncthing's settings/keys

    # Web GUI will be available at http://127.0.0.1:8384/
    guiAddress = "127.0.0.1:8384";

    openDefaultPorts = false;
  };

}
