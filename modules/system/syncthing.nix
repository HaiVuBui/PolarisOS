{ username, ... }:
{
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";

    # Web GUI will be available at http://127.0.0.1:8384/
    guiAddress = "127.0.0.1:8384";

    openDefaultPorts = false;
  };

}
