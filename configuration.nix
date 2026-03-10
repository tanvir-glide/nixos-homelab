{ config, pkgs, ... }:

{
  imports = [
      
    # Hardware
    ./hardware-configuration.nix

    # Storage
    ./modules/hardware/storage.nix

    ];

  
  # Enabling flakes
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      };

  # Settings up garbage collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Some shell aliases for long commands
  environment.shellAliases = {
    nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    nix-clean = "sudo nix-collect-garbage -d";
    neofetch = "clear ; fastfetch";
  };


  # Automatic update at 4am
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "Fri 04:00";
  };

 }
