{ lib, ... }: {
  # fileSystems."/home/hai/Storage" = {
  #   device = "/dev/disk/by-uuid/f7ed8d00-bcb0-44bc-ab00-2fc383b45926";
  #   fsType = "btrfs";
  #   options = [ "subvol=STORAGE" "compress=zstd:3" "noatime" "nofail"]; 
  # };
  #
  # fileSystems."/Backup" = {
  #   device = "/dev/disk/by-uuid/f7ed8d00-bcb0-44bc-ab00-2fc383b45926";
  #   fsType = "btrfs";
  #   options = [ "subvol=BACKUP" "compress=zstd:3" "noatime" "nofail"]; 
  # };
  #
  # fileSystems."/snapshots" = {
  #   device = "/dev/disk/by-uuid/f7ed8d00-bcb0-44bc-ab00-2fc383b45926";
  #   fsType = "btrfs";
  #   options = [ "subvol=SNAPSHOTS" "compress=zstd:3" "noatime" "nofail"]; 
  # };

  # fileSystems."/home/hai/Win" = {
  #   device = "/dev/disk/by-uuid/A6C6D62EC6D5FF0D";
  #   fsType = "ntfs-3g";
  #   options = [ "nofail" "rw" "uid=1000" "gid=1000" "windows_names" ];
  # };

  fileSystems."/".options = lib.mkForce [ "subvol=root" "compress=zstd" ];
  fileSystems."/home".options = lib.mkForce [ "subvol=home" "compress=zstd" ];
  fileSystems."/nix".options = lib.mkForce [ "subvol=nix" "compress=zstd" "noatime" ];
}
