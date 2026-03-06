# modules/core/users.nix
{ config, pkgs, lib, ... }:
{
  # User configuration
  users.users.tanvir = {
    isNormalUser = true;
    description = "Tanvir";
    extraGroups = [ "wheel" "networkmanager" "docker" ];  
    shell = pkgs.bash;
    
 };
}
