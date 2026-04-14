# modules/security/firewall.nix
{ config, pkgs, lib, ... }:
let
  ports = {
    navidrome = 14533;
    slskd-web = 15030;
    slskd-transfer = 50300;  # UDP
    qbittorrent = 18080;
    gotify = 8085;
    minecraft = 46565;
    tailscale = 41641;        # UDP
    microbin = 18081;
    focalboard = 18000;
    caddy = 80;
    caddy-ssl = 443;
  };
in
{
  networking.firewall = {
    enable = true;
    
    # Trust Tailscale interface
    trustedInterfaces = [ "tailscale0" ];
    
    # Open TCP ports
    allowedTCPPorts = [
      ports.caddy
      ports.caddy-ssl
      ports.navidrome
      ports.slskd-web
      ports.qbittorrent
      ports.minecraft
      ports.focalboard
      ports.microbin
    ];
    
    # Open UDP ports
    allowedUDPPorts = [
      ports.slskd-transfer
      ports.tailscale
    ];
    
    checkReversePath = "loose";    
  };
  
}
