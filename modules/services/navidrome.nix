{ config, pkgs, ... }:

{
  age.secrets.lastfm = {
    file = ../../secrets/lastfm.age;
    owner = "navidrome";
  };

  services.navidrome = {
    enable = true;

    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/Files/Music";

      # Environment variables
      ScanSchedule = "1h";
      LogLevel = "info";
      ImageCacheSize = "500MB";
      LastFM.Enabled = true;
    };
  };

  systemd.services.navidrome = {
    serviceConfig = {
      SupplementaryGroups = [ "users" ];
      EnvironmentFile = config.age.secrets.lastfm.path;
    };
    requires = [ "mnt-Files.mount" ];
    after = [ "mnt-Files.mount" ];
  };
}
