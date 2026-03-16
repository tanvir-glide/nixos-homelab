# modules/core/packages/user-packages.nix
{ config, pkgs, lib, ... }:
let
  # User-specific package lists
  userPackages = with pkgs; [
    # fetch / montioring tools
    fastfetch
    btop
    pfetch-rs
    
    # Help
    tldr
    
    # Shell enhancements
    fzf
    tree
    
    # Remote access
    mosh
    
    # File management
    ranger
    gdu
    
    # Text processing
    jq      # JSON processor
    yq      # YAML processor
  ];
in
{
  # Apply to your user
  users.users.tanvir = {
    # ... existing user config ...
    packages = userPackages;
  };
}
