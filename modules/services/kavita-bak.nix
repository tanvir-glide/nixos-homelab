# modules/services/kavita.nix
{ config, pkgs, vars, ... }:

{
  services.kavita = {
    enable = true;
    settings.Port = 5000; 
    
    
    tokenKeyFile = "/var/lib/kavita/token.key"; 
  };

  users.groups.users.members = [ "kavita" ];

  systemd.services.kavita = {
    requires = [ "mnt-Files.mount" ];
    after = [ "mnt-Files.mount" ];
  };
}
