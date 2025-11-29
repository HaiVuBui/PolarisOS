{ config, pkgs, ... }:
{
  services.mpd = {
    enable = true;
    package = pkgs.mpd;
    dataDir = "${config.xdg.stateHome}/mpd";
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.xdg.dataHome}/mpd/playlists";
    network.listenAddress = "127.0.0.1";
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"

      audio_output {
        type "pulse"
        name "PulseAudio"
      }
    '';
  };

  home.packages = with pkgs; [
    mpc-cli
  ];
}
