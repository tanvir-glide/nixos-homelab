{
  config,
  pkgs,
  ...
}: {
  # Dedicated unprivileged user for accessing the
  users.users.nfsmedia = {
    isSystemUser = true;
    uid = 2000;
    group = "nfsmedia";
    description = "NFS media share anonymous mapper";
  };

  users.groups.nfsmedia.gid = 2000;

  # 2. NFS server with restricted clients and secure mapping
  services.nfs.server = {
    enable = true;
    mountdPort = 4002;
    statdPort = 4000;
    lockdPort = 4001;

    exports = ''
      /mnt/Files/Movies *(ro,sync,no_subtree_check,all_squash,root_squash,anonuid=2000,anongid=2000,insecure)
      /mnt/More/Anime  *(ro,sync,no_subtree_check,all_squash,root_squash,anonuid=2000,anongid=2000,insecure)
    '';
  };
}
