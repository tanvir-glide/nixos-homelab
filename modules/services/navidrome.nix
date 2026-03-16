{ config, pkgs, ... }:

{
  services.navidrome = {
    enable = true;
    
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/Files/Music";
      
      # Environment variables
      ScanSchedule = "1h";
      LogLevel = "info";
      SessionTimeout = "24h";
      ImageCacheSize = "500MB";
      LastFM.Enabled = true;
    };
  };

  systemd.services.navidrome= {
    serviceConfig = {
    SupplementaryGroups = [ "users" ];   };
    requires = [ "mnt-Files.mount" ];
    after = [ "mnt-Files.mount" ];
  };
}
