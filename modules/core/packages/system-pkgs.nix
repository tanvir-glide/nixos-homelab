# modules/core/packages/system-pkgs.nix
{ config, pkgs, lib, ... }:
{
  
  environment.systemPackages = with pkgs; [
    # Essential system tools
    wget
    curl
    rsync

    # Editor
    vim                     # Default editor
    helix

    # Network
    tailscale
    
    # Network debugging
    mtr
    tcpdump
    dig
    
    # System monitoring
    btop
    
    # Nix-specific tools
    nix-tree
    nix-output-monitor

    # laptop specific
    auto-cpufreq
    
    # Dev
    gcc
    go

    # 

  ];
  
  # Default editor for system (sudo will use this)
  environment.variables.EDITOR = "vim";
  
}
