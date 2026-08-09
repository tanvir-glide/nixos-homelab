{
  config,
  pkgs,
  vars,
  ...
}: {
  services.caddy = {
    enable = true;
    user = "caddy";
    group = "caddy";

    virtualHosts = {
      # Main Dashboard
      "nixos.tail223014.ts.net" = {
        extraConfig = "reverse_proxy 127.0.0.1:3000";
      };

      # Navidrome
      "nixos.tail223014.ts.net:14533" = {
        extraConfig = "reverse_proxy 127.0.0.1:4533";
      };

      # Slskd
      "nixos.tail223014.ts.net:15030" = {
        extraConfig = "reverse_proxy 127.0.0.1:5030";
      };

      # Transmission torrent client
      "nixos.tail223014.ts.net:18080" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080 {
            header_up Host 127.0.0.1:8080
          }
        '';
      };

      # Beszel
      "nixos.tail223014.ts.net:18090" = {
        extraConfig = "reverse_proxy 127.0.0.1:8090";
      };

      # Focalboard
      "nixos.tail223014.ts.net:18000" = {
        extraConfig = "reverse_proxy 127.0.0.1:8000";
      };

      # Microbin
      "nixos.tail223014.ts.net:18081" = {
        extraConfig = "reverse_proxy 127.0.0.1:8081";
      };

      # Kavita (Manga Reader)
      "nixos.tail223014.ts.net:15000" = {
        extraConfig = "reverse_proxy 127.0.0.1:5000";
      };

      # Metadata-remote
      "nixos.tail223014.ts.net:18338" = {
        extraConfig = "reverse_proxy 127.0.0.1:8338";
      };
    };
  };
}
