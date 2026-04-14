{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    user = "caddy";
    group = "caddy";

    virtualHosts = {
      # Main Dashboard
      "nixos-server.tail223014.ts.net" = {
        extraConfig = ''
          root * /var/www/
          file_server
        '';
      };

      # Navidrome
      "nixos-server.tail223014.ts.net:14533" = {
        extraConfig = "reverse_proxy 127.0.0.1:4533";
      };

      # Slskd
      "nixos-server.tail223014.ts.net:15030" = {
        extraConfig = "reverse_proxy 127.0.0.1:5030";
      };

      # qBittorrent
      "nixos-server.tail223014.ts.net:18080" = {
        extraConfig = "reverse_proxy 127.0.0.1:8080" ;
      };

      # Focalboard
      "nixos-server.tail223014.ts.net:18000" = {
        extraConfig = "reverse_proxy 127.0.0.1:8000";
      };

      # Microbin
      "nixos-server.tail223014.ts.net:18081" = {
        extraConfig = "reverse_proxy 127.0.0.1:8081";
      };

      # Metadata-remote
      "nixos-server.tail223014.ts.net:18338" = {
        extraConfig = "reverse_proxy 127.0.0.1:8338";
      };
    };
  };
}
