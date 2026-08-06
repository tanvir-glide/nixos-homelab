# modules/services/transmission.nix
{
  config,
  pkgs,
  ...
}: {
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4; # Uses Transmission 4

    user = "tanvir";
    group = "users";

    # Enable peer-to-peer incoming port forwarding automatically in the firewall
    openPeerPorts = true;

    settings = {
      # Bind RPC to localhost so only Caddy accesses it directly
      rpc-bind-address = "127.0.0.1";
      rpc-port = 8080;
      rpc-whitelist-enabled = false;

      # File layout mapping matching your system
      download-dir = "/mnt/More/Torrent";
      incomplete-dir = "/mnt/More/Torrent/.incomplete";
      incomplete-dir-enabled = true;

      # Permission mask configuration: allows the group 'transmission' full rwx permissions
      umask = 2; # Files created get 775/664, enabling write access for the group
    };
  };

  # Give your user direct read/write rights to torrent directories
  # by putting your primary user account in the transmission group
  users.users.tanvir.extraGroups = ["transmission"];
}
