{
  config,
  pkgs,
  ...
}: {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 3000;

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          uptime = true;
        };
      }
    ];

    settings = {
      title = "NixOS Homelab";
      favicon = "https://raw.githubusercontent.com/NixOS/nix/refs/heads/master/doc/manual/source/favicon.svg";
    };

    services = [
      {
        "Media & Downloads" = [
          {
            "Navidrome" = {
              icon = "navidrome.png";
              href = "https://nixos.tail223014.ts.net:14533";
              description = "Music streaming service";

              widget = {
                type = "navidrome";
                url = "https://nixos.tail223014.ts.net:14533";
                user = "tanvir";
                token = "7d8e734f4bf2a5953d7320853340d8c8";
                salt = "nixoshomelab";
              };
            };
          }

          {
            "Komga" = {
              icon = "komga.png";
              href = "http://nixos.tail223014.ts.net:15000";
              description = "Comic & Manga Media Server";
            };
          }

          {
            "Transmission" = {
              icon = "transmission.png";
              href = "http://nixos.tail223014.ts.net:18080";
              description = "BitTorrent client";

              widget = {
                type = "transmission";
                # Force the widget backend to use HTTPS via your working Tailscale route
                url = "https://nixos.tail223014.ts.net:18080";
              };
            };
          }

          {
            "Slskd" = {
              icon = "soulseek.png";
              href = "http://nixos.tail223014.ts.net:15030";
              description = "Soulseek P2P client";
              siteMonitor = "https://nixos.tail223014.ts.net:15030";
            };
          }

          {
            "Metadata Remote" = {
              icon = "https://raw.githubusercontent.com/wow-signal-dev/metadata-remote/refs/heads/main/screenshots/mdrm-icon-for-light-bg.svg";
              href = "http://nixos.tail223014.ts.net:18338";
              description = "Metadata processing backend";
              siteMonitor = "https://nixos.tail223014.ts.net:18338";
            };
          }
        ];
      }

      {
        "Management & Productivity" = [
          {
            "Beszel" = {
              icon = "beszel.png";
              href = "http://nixos.tail223014.ts.net:18090";
              description = "Lightweight resource monitor";

              widget = {
                type = "beszel";
                url = "https://nixos.tail223014.ts.net:18090";
                username = "<your_email>@gmail.com";
                password = "<your_passwd>";
                version = 2;
              };
            };
          }

          {
            "Focalboard" = {
              icon = "focalboard.png";
              href = "http://nixos.tail223014.ts.net:18000";
              description = "Project and task management";
              siteMonitor = "https://nixos.tail223014.ts.net:18000";
            };
          }
          {
            "Microbin" = {
              icon = "microbin.png";
              href = "http://nixos.tail223014.ts.net:18081";
              description = "Self-hosted pastebin application";
              siteMonitor = "https://nixos.tail223014.ts.net:18081";
            };
          }
        ];
      }
    ];
  };

  systemd.services.homepage-dashboard.environment = {
    HOMEPAGE_ALLOWED_HOSTS = pkgs.lib.mkForce "nixos.tail223014.ts.net,127.0.0.1";
  };
}
