{ config, pkgs, ... }:

{
  # Caddy service for website
  services.caddy = {
    enable = true;
    virtualHosts."100.120.226.4" = {
      extraConfig = ''
        root * /var/www/dashboard
        file_server
        header {
          # Optional: Security headers for that Apple-clean feel
          Strict-Transport-Security "max-age=31536000;"
          X-Content-Type-Options nosniff
          X-Frame-Options DENY
        }
      '';
    };
  };
}
