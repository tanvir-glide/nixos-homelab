{ config, pkgs, lib, ... }:
{
  fileSystems = {

  "/mnt/Files" = {
    device = "/dev/disk/by-uuid/01D858C886F164A0";
    fsType = "ntfs3";
    options = [ "defaults" "uid=1000" "gid=1000" "umask=022" "nofail" "force" "x-systemd.automount" ];
  };

  "/mnt/More" = {
    device = "/dev/disk/by-uuid/01D858C8BFF86460";
    fsType = "ntfs3";
    options = [ "defaults" "uid=1000" "gid=1000" "umask=022" "nofail" "force" "x-systemd.automount" ];
  };

  "/mnt/Games" = {
    device = "/dev/disk/by-uuid/01D858C8DC3DA2C0";
    fsType = "ntfs3";
    options = [ "defaults" "uid=1000" "gid=1000" "umask=022" "nofail" "force" "x-systemd.automount" ];
  };
 };
}
