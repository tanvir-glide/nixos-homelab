{ config, pkgs, lib, ... }:

let
   
  dataDir = "/var/lib/docker-containers";

  defaultContainer = {
    restart = "unless-stopped";
    environment = {
      PUID = "1000";
      PGID = "100";
      TZ = "Asia/Dhaka";
    };
  };

  containers = {

    # Navidrome
    navidrome = lib.recursiveUpdate defaultContainer {
      image = "deluan/navidrome:latest";

      ports = [ "4533:4533" ];

      environment = {
        ND_SCANSCHEDULE = "1h";
        ND_LOGLEVEL = "info";
        ND_SESSIONTIMEOUT = "24h";
        ND_IMAGECACHESIZE = "500MB";
        ND_LASTFM_ENABLED = "true";
      };

      volumes = [
        "${dataDir}/data:/data"
        "/mnt/Files/Music:/music:ro"
      ];
    };


    # Slskd 
    slskd = lib.recursiveUpdate defaultContainer {
      image = "ghcr.io/slskd/slskd:latest";

      ports = [
        "5030:5030"
        "5031:5031"
        "50300:50300"
        "50300:50300/udp"
      ];

      environment = {
        SLSKD_REMOTE_CONFIGURATION = "true";

        SLSKD_SOULSEEK_USERNAME = "YouSoulSeekUsername";
        SLSKD_SOULSEEK_PASSWORD = "YOurSoulSeekPasswrd";

        SLSKD_DIRECTORIES_DOWNLOADS = "/music";
        SLSKD_DIRECTORIES_INCOMPLETE = "/music/.incomplete";

        SLSKD_SHARES_DIRECTORIES__0 = "/music";

      };
      

      volumes = [
        "${dataDir}/slskd/config:/config"
        "${dataDir}/slskd/data:/app/slskd"
        "/mnt/Files/Music:/music"
      ];
    };

    # qBittorrent
    qbittorrent = lib.recursiveUpdate defaultContainer {
      image = "lscr.io/linuxserver/qbittorrent:latest";

      ports = [
        "8080:8080"
        "6881:6881"
        "6881:6881/udp"
      ];

      environment = {
        WEBUI_PORT = "8080";
      };

      volumes = [
        "${dataDir}/config:/config"
        "/mnt/Files/Torrent:/downloads"
      ];
    };

    # Microbin    
    microbin = lib.recursiveUpdate defaultContainer {
      image = "danielszabo99/microbin:latest";

      ports = [ "8081:8080" ];

      volumes = [
        "${dataDir}/microbin-data:/app/persist"
      ];
    };

    # Metadata-editor
    metadata-remote = lib.recursiveUpdate defaultContainer {
      image = "ghcr.io/wow-signal-dev/metadata-remote:latest";

      ports = ["8338:8338"];

      volumes = [
        "/mnt/Files/Music:/music"
      ];

      environment = {
        
      };

      healthcheck = {
        test = [ "CMD" "wget" "--no-verbose" "--tries=1" "--spider" "http://127.0.0.1:8338" ];
        interval = "30s";
        timeout = "10s";
        retries = 3;
        start_period = "40s";
      };
    };

    # Focalboard
    focalboard = lib.recursiveUpdate defaultContainer {
      image = "mattermost/focalboard:latest";

      ports = [ "8000:8000" ];

      volumes = [
        "${dataDir}/fbdata:/data"
      ];
    };
  };

  dockerCompose = pkgs.writeText "docker-compose.yml"
    (builtins.toJSON {
      version = "3.8";
      services = containers;
    });

  dockerctl = pkgs.writeShellScriptBin "dockerctl" ''
    COMPOSE=${dockerCompose}
    DC=${pkgs.docker-compose}/bin/docker-compose

    case "$1" in
      up)
        echo "Pulling images..."
        $DC -f "$COMPOSE" pull
        echo "Starting containers..."
        $DC -f "$COMPOSE" up -d
        ;;
      down)
        echo "Stopping containers..."
        $DC -f "$COMPOSE" down --remove-orphans
        ;;
      restart)
        $DC -f "$COMPOSE" down
        $DC -f "$COMPOSE" up -d
        ;;
      logs)
        $DC -f "$COMPOSE" logs -f
        ;;
      ps)
        $DC -f "$COMPOSE" ps
        ;;
      *)
        echo "Usage: dockerctl {up|down|restart|logs|ps}"
        ;;
    esac
  '';

in
{
  environment.systemPackages = with pkgs; [
    docker-compose
    dockerctl
  ];

  virtualisation.docker.enable = true;

  systemd.tmpfiles.rules =
    map (d: "d ${dataDir}/${d} 0755 tanvir users -") [
      "data"
      "config"
      "fbdata"
      "microbin-data"
      "slskd/config"
      "slskd/data"
    ];

  systemd.services.docker-containers = {
    description = "Docker Compose Containers";

    after = [ "docker.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    requires = [ "docker.service" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = "${dockerctl}/bin/dockerctl up";
      ExecStop = "${dockerctl}/bin/dockerctl down";

      TimeoutStartSec = "5min";
    };
  };
}
