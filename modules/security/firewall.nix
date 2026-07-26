# modules/security/firewall.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  ports = {
    navidrome = 14533;
    slskd-web = 15030;
    slskd-transfer = 50300; # UDP
    qbittorrent = 18080;
    minecraft = 46565;
    tailscale = 41641; # UDP
    microbin = 18081;
    focalboard = 18000;
    caddy = 80;
    caddy-ssl = 443;
  };
in
{
  networking.firewall = {
    enable = true;

    # Trust Tailscale & Podman interface
    trustedInterfaces = [ "tailscale0" "podman0" ];

    # Open TCP ports
    allowedTCPPorts = [ 53
    ];

    # Open UDP ports
    allowedUDPPorts = [
      ports.slskd-transfer
      ports.tailscale
      53
    ];

    checkReversePath = "loose";
  };

}
