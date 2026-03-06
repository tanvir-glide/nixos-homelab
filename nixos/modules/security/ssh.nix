# modules/security/ssh.nix
{ config, pkgs, lib, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    
  };
  
  # Pubkey
  users.users.tanvir.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6KaudWVwILSHjzNOCF3RDH27uiJOTlRXzkpVbeHvAf mac -> hp"
  ];
  
 }
