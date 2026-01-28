{ lib, ... }: {
  fileSystems."/home/hai/Storage" = {
    device = "/dev/disk/by-uuid/e973dce2-7d2e-412f-ba99-722ed58dbd55";
    fsType = "btrfs";
    options = [ "subvol=storage" "compress=zstd:3" "autodefrag" "noatime"]; 
  };

  fileSystems."/home/hai/Archive" = {
    device = "/dev/disk/by-uuid/e973dce2-7d2e-412f-ba99-722ed58dbd55";
    fsType = "btrfs";
    options = [ "subvol=archive" "compress=zstd:3" "autodefrag" "noatime"]; 
  };

  fileSystems."/home/hai/Win" = {
    device = "/dev/disk/by-uuid/A6C6D62EC6D5FF0D";
    fsType = "ntfs-3g";
    options = [ "nofail" "rw" "uid=1000" "gid=1000" "windows_names" ];
  };

  fileSystems."/".options = lib.mkForce [ "subvol=root" "compress=zstd" ];
  fileSystems."/home".options = lib.mkForce [ "subvol=home" "compress=zstd" ];
  fileSystems."/nix".options = lib.mkForce [ "subvol=nix" "compress=zstd" "noatime" ];
}
