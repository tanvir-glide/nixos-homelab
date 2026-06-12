{ config, pkgs, vars, ... }:

{
  services.caddy = {
    enable = true;
    user = "caddy";
    group = "caddy";

    virtualHosts = {
      # Main Dashboard
      "${vars.tailscaleHostname}" = {
        extraConfig = ''
          root * /var/www/
          file_server
        '';
      };

      # Navidrome
      "${vars.tailscaleHostname}:14533" = {
        extraConfig = "reverse_proxy 127.0.0.1:4533";
      };

      # Slskd
      "${vars.tailscaleHostname}:15030" = {
        extraConfig = "reverse_proxy 127.0.0.1:5030";
      };

      # qBittorrent
      "${vars.tailscaleHostname}:18080" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080 {
            header_up Host 127.0.0.1:8080
          }
        '';
      };

      # Focalboard
      "${vars.tailscaleHostname}:18000" = {
        extraConfig = "reverse_proxy 127.0.0.1:8000";
      };

      # Microbin
      "${vars.tailscaleHostname}:18081" = {
        extraConfig = "reverse_proxy 127.0.0.1:8081";
      };

      # Metadata-remote
      "${vars.tailscaleHostname}:18338" = {
        extraConfig = "reverse_proxy 127.0.0.1:8338";
      };
    };
  };
}
