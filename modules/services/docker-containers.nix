{ config, lib, pkgs, ... }:

let
  dataDir = "/var/lib/docker-containers";

  commonEnv = {
    PUID = "1000";
    PGID = "100";
    TZ = "Asia/Dhaka";
  };

  mkData = name: "${dataDir}/${name}";

  slskdConfig = pkgs.writeText "slskd.yml" ''
    soulseek:
      username: "YourSoulseekUsername"
      password: "YourSoulseekPassword"

    directories:
      downloads: /music
      incomplete: /music/.incomplete

    shares:
      directories:
        - /music

    '';

in

{
  virtualisation = {
    docker.enable = true;

    oci-containers = {
      backend = "docker";

      containers = {

        # SLSKD
        slskd = {
          image = "ghcr.io/slskd/slskd:latest";

          ports = [
            "127.0.0.1:5030:5030"
            "127.0.0.1:5031:5031"
            "50300:50300"
            "50300:50300/udp"
          ];

          environment = commonEnv // {
            SLSKD_REMOTE_CONFIGURATION = "true";
          };

          volumes = [
            "${mkData "slskd/config"}:/config"
            "${mkData "slskd/data"}:/app/slskd"
            "/mnt/Files/Music:/music"
            "${slskdConfig}:/app/slskd.yml"
          ];
        };
        
        # qBittorrent
        qbittorrent = {
          image = "lscr.io/linuxserver/qbittorrent:latest";

          ports = [
            "127.0.0.1:8080:8080"
            "6881:6881"
            "6881:6881/udp"
          ];

          environment = commonEnv // {
            WEBUI_PORT = "8080";

            WEBUI_REVERSE_PROXY = "true";
            WEBUI_HOST_HEADER_VALIDATION = "false";
          };

          volumes = [
            "${mkData "config"}:/config"
            "/mnt/More/Torrent:/downloads"
          ];
        };

        # Microbin
        microbin = {
          image = "danielszabo99/microbin:latest";

          ports = [ "127.0.0.1:8081:8080" ];

          environment = commonEnv;

          volumes = [
            "${mkData "microbin-data"}:/app/persist"
          ];
        };
        
        # Music Metadata Editor
        metadata-remote = {
          image = "ghcr.io/wow-signal-dev/metadata-remote:latest";

          ports = [ "127.0.0.1:8338:8338" ];

          environment = commonEnv;

          volumes = [
            "/mnt/Files/Music:/music"
          ];

          extraOptions = [
            "--health-cmd=wget --no-verbose --tries=1 --spider http://127.0.0.1:8338 || exit 1"
            "--health-interval=30s"
            "--health-timeout=10s"
            "--health-retries=3"
            "--health-start-period=40s"
          ];
        };

        # Focalboard
        focalboard = {
          image = "mattermost/focalboard:latest";

          ports = [ "127.0.0.1:8000:8000" ];

          environment = commonEnv;

          volumes = [
            "${mkData "fbdata"}:/data"
          ];
        };

                
      };
    };
  };

  systemd.tmpfiles.rules =
    map (d: "d ${mkData d} 0755 tanvir users -") [
      "data"
      "config"
      "fbdata"
      "microbin-data"
      "slskd/config"
      "slskd/data"
    ];
}
