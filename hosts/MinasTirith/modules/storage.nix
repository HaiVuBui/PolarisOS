{ ... }: {
  fileSystems."/home/hai/Backup" = {
    device = "/dev/disk/by-uuid/165cf380-9f13-4d83-9915-c57288e1e64a";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/hai/Storage" = {
    device = "/dev/disk/by-uuid/8433d491-2a37-48bb-b0e7-5e739f972814";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/hai/Win" = {
    device = "/dev/disk/by-uuid/A6C6D62EC6D5FF0D";
    fsType = "ntfs-3g";
    options = [ "nofail" "rw" "uid=1000" "gid=1000" "windows_names" ];
  };
}
