{
  config,
  lib,
  username,
  ...
}:
lib.mkIf config.polaris.features.qbittorrent {
  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences.WebUI = {
        Username = username;
        Password_PBKDF2 = "@ByteArray(4r3KsT46LcdyfVR2UdqaXQ==:YMH01VI7bcb3Ml6M7FTUIrEVgQJz0sKNXJ988njKBM9LnwkEfWHZSFSY2NFsbviPMP9UJH81P2W3i838hioIKw==)";
      };
    };
  };
}
