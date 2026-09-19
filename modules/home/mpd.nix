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

  # mpd speaks no MPRIS of its own, so nothing on the bar can see or seek it
  services.mpd-mpris.enable = true;

  home.packages = with pkgs; [
    mpc
  ];
}
