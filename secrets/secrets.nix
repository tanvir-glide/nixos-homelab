let

  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONaxNrdBoqgDjhHXe7JW4LMxI9uXIB5u9QdTexJDq+u root@nixos";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4T+hDRRT6cezLQ8VRTYoBLS48HB6fiI0atupZJ6Eko tanvir@nixos";
in
{
  "lastfm.age".publicKeys = [
    server
    user
  ];
}
