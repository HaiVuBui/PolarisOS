{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xdg-utils ];

  xdg.mime.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = "helium.desktop";
    "x-scheme-handler/http" = "helium.desktop";
    "x-scheme-handler/https" = "helium.desktop";
    "x-scheme-handler/about" = "helium.desktop";
    "x-scheme-handler/unknown" = "helium.desktop";
  };
}

