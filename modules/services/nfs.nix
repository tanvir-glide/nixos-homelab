{
  config,
  pkgs,
  ...
}: {
  # Enable NFS Kernel Server
  services.nfs.server = {
    enable = true;

    mountdPort = 4002;
    statdPort = 4000;
    lockdPort = 4001;

    exports = ''
      /mnt/Files/Movies *(ro,sync,no_subtree_check,all_squash,anonuid=0,anongid=0,insecure,no_auth_nlm)
      /mnt/More/Anime  *(ro,sync,no_subtree_check,all_squash,anonuid=0,anongid=0,insecure,no_auth_nlm)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [111 2049 4000 4001 4002];
    allowedUDPPorts = [111 2049 4000 4001 4002];
  };
}
