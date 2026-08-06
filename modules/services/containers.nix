{
  config,
  lib,
  pkgs,
  ...
}: let
  dataDir = "/var/lib/docker-containers";

  commonEnv = {
    PUID = "1000";
    PGID = "100";
    TZ = "Asia/Dhaka";
  };

  mkData = name: "${dataDir}/${name}";

  slskdConfig = pkgs.writeText "slskd.yml" ''
    soulseek:
      username: "Tanvirkdsw2345678io"
      password: "CWE$%^7ijft6ytre56789o"

    directories:
      downloads: /music
      incomplete: /music/.incomplete

    shares:
      directories:
        - /music

  '';
in {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers = {
      backend = "podman";

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

          environment =
            commonEnv
            // {
              SLSKD_REMOTE_CONFIGURATION = "true";
            };

          volumes = [
            "${mkData "slskd/config"}:/config"
            "${mkData "slskd/data"}:/app/slskd"
            "/mnt/Files/Music:/music"
            "${slskdConfig}:/app/slskd.yml"
          ];
        };

        # Microbin
        microbin = {
          image = "danielszabo99/microbin:latest";

          ports = ["127.0.0.1:8081:8080"];

          environment = commonEnv;

          volumes = [
            "${mkData "microbin-data"}:/app/persist"
          ];
        };

        # Music Metadata Editor
        metadata-remote = {
          image = "ghcr.io/wow-signal-dev/metadata-remote:latest";

          ports = ["127.0.0.1:8338:8338"];

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

          ports = ["127.0.0.1:8000:8000"];

          environment = commonEnv;

          volumes = [
            "${mkData "fbdata"}:/data"
          ];
        };

        # Manga Reader
        komga = {
          image = "gotson/komga:latest";

          ports = ["5000:25600"];
          volumes = [
            "/var/lib/komga:/config"
            "/mnt/More/Manga:/data"
          ];
        };
      };
    };
  };

  systemd.tmpfiles.rules = map (d: "d ${mkData d} 0755 tanvir users -") [
    "data"
    "config"
    "fbdata"
    "microbin-data"
    "slskd/config"
    "slskd/data"
  ];
}
