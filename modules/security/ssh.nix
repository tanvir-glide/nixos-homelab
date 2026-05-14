{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];

    extraConfig = ''
      UseDNS no
    '';

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

  };

  # Pubkey
  users.users.tanvir.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsz5bi/aOn2PBoaAJ7fYU2glIutxUC86Ki9lIQIMTLV mac -> homelab"
  ];

}
