{ config, pkgs, ... }:

{
  imports = [
      
    # Hardware
    ./hardware-configuration.nix

    # Storage
    ./modules/hardware/storage.nix

    ];

  
  # Enabling flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some shell aliases for long commands
  environment.shellAliases = {
    nix-switch = "sudo nixos-rebuild switch";
    nix-clean = "sudo nix-collect-garbage -d";
    nix-conf = "sudoedit /etc/nixos/configuration.nix";
    neofetch = "clear ; fastfetch";
  };

  # Settings up garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  # Automatic update at 4am
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "Fri 04:00";
  };

 }
