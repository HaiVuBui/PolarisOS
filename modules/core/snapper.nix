{ config, pkgs, username, ... }:

{
  # 1. Enable the Snapper service
  services.snapper.configs = {
    "root" = {
      # The exact path where the subvolume is mounted
      SUBVOLUME = "/";
      
      # Permissions: Allow your user to use snapper commands without sudo
      ALLOW_USERS = [ "${username}" ];
      
      # Timer settings: How often to take auto-snapshots
      TIMELINE_CREATE = false;
      TIMELINE_CLEANUP = false;
      
      # Retention policy: Keep 10 hourly, 2 daily, etc.
      # TIMELINE_LIMIT_HOURLY = "10";
      # TIMELINE_LIMIT_DAILY = "2";
      # TIMELINE_LIMIT_WEEKLY = "0";
      # TIMELINE_LIMIT_MONTHLY = "0";
      # TIMELINE_LIMIT_YEARLY = "0";
    };

    "home" = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ "${username}" ];
      TIMELINE_CREATE = false;
      TIMELINE_CLEANUP = false;
    };
    
    "storage" = {
      SUBVOLUME = "/home/${username}/Storage";
      ALLOW_USERS = [ "${username}" ];
      TIMELINE_CREATE = false;
      TIMELINE_CLEANUP = false;
    };

    "archive" = {
      SUBVOLUME = "/home/${username}/Archive";
      ALLOW_USERS = [ "${username}" ];
      TIMELINE_CREATE = false;
      TIMELINE_CLEANUP = false;
    };
  };
}
