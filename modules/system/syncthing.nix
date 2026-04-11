{ ... }:
{
  services.syncthing = {
      enable = true;
      user = "hai"; # REPLACE with your actual username
      dataDir = "/home/hai";    # Default folder for new synced directories
      configDir = "/home/hai/.config/syncthing"; # Folder for Syncthing's settings/keys
      
      # Web GUI will be available at http://127.0.0.1:8384/
      guiAddress = "127.0.0.1:8384";
      
      # Open default ports (22000 for sync, 21027 for discovery)
      # Since you use Tailscale, strictly speaking, you only need these open on tailscale0,
      # but this is the easiest way to ensure it works.
      openDefaultPorts = true; 
  };
  
}
