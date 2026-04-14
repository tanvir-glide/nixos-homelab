{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    user = "caddy";
    group = "caddy";

    # Main Dashboard
    virtualHosts."nixos-server.tail223014.ts.net" = {
      extraConfig = ''
        root * /var/www/
        file_server
      '';
    };

    # Navidrome
    virtualHosts."nixos-server.tail223014.ts.net:14533" = {
      extraConfig = "reverse_proxy 127.0.0.1:4533";
    };

    # Slskd
    virtualHosts."nixos-server.tail223014.ts.net:15030" = {
      extraConfig = "reverse_proxy 127.0.0.1:5030";
    };

    # qBittorrent
    virtualHosts."nixos-server.tail223014.ts.net:18080" = {
      extraConfig = "reverse_proxy 127.0.0.1:8080" ;
    };

    # Focalboard 
    virtualHosts."nixos-server.tail223014.ts.net:18000" = {
      extraConfig = "reverse_proxy 127.0.0.1:8000";
    };

    # Microbin
    virtualHosts."nixos-server.tail223014.ts.net:18081" = {
      extraConfig = "reverse_proxy 127.0.0.1:8081";
    };
    
    # Metadata-remote
    virtualHosts."nixos-server.tail223014.ts.net:18338" = {
      extraConfig = "reverse_proxy 127.0.0.1:8338";
    };
  };
}
