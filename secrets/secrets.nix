let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXRlq29NbQ6bFhm/P9qEQe7lDfg2C4ZiL56tnUstmON root@nixos";
  mac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDh9crtIuxl/zQyH+mUX+5WjsfwLLN8f76fM+VG9bE7w tanvir@Tanvirs-MacBook-Air.local";
in {
  "lastfm.age".publicKeys = [
    server
    mac
  ];
}
