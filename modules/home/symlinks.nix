{ config, ... }:

{
  # ... your other config ...

  home.file = {
    # Link 1: Textbooks
    # The key is where the LINK goes (relative to your home dir)
    "GrandArchive/Textbooks".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/Textbooks";

    # Link 2: Papers
    "GrandArchive/Papers".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/Papers";

    # Link 3: Wallpapers
    "Wallpapers".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/PolarisOS/wallpapers";
  };
}
