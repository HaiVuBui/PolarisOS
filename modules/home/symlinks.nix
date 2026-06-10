{ config, ... }:

{
  # Out-of-store symlinks: the link lives in $HOME, the target stays mutable.
  home.file = {
    "GrandArchive/Textbooks".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/Textbooks";

    "GrandArchive/Papers".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/Papers";

    "Wallpapers".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/PolarisOS/wallpapers";
  };
}
