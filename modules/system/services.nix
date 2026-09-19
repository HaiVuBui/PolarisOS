{ pkgs, ... }:
{
  # Services to start
  services = {
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    gvfs.enable = true; # For Mounting USB & More
    openssh = {
      enable = true; # Enable SSH
      openFirewall = false;
    };
    blueman.enable = false; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
    gnome.gnome-keyring.enable = true;
    upower.enable = true; # Power management (required for DMS battery monitoring)
    usbmuxd.enable = true;
    udisks2.enable = true;
    cloudflare-warp.enable = true;

    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    smartd = {
      enable = true;
      autodetect = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true; # Enable WirePlumber session manager
    };
  };
}
