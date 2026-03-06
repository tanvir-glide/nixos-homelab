# modules/security/firewall.nix
{ config, pkgs, lib, ... }:
let
  ports = {
    navidrome = 4533;
    slskd-web = 5030;
    slskd-transfer = 50300;  # UDP
    qbittorrent = 8080;
    minecraft = 46565;
    tailscale = 41641;        # UDP
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
      ports.navidrome
      ports.slskd-web
      ports.qbittorrent
      ports.minecraft
    ];
    
    # Open UDP ports
    allowedUDPPorts = [
      ports.slskd-transfer
      ports.tailscale
    ];
    
    checkReversePath = "loose";    
  };
  
}
