# modules/core/network.nix
{ config, pkgs, lib, ... }:
{
    networking = {
        hostName = "nixos";
        networkmanager.enable = true;

        # DNS
        nameservers = [
            "1.1.1.1"
            "8.8.8.8"
        ];
    };

    # Enable tailscale
    services.tailscale.enable = true;
}
