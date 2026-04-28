{
  config,
  pkgs,
  lib,
  ...
}:

{
  # User configuration
  users.users.tanvir = {
    isNormalUser = true;
    description = "Tanvir";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];

    hashedPassword = "$6$gzeT9LDJejt49n84$/YkYbEFhO1ZktJJzVEVBkAOL3yhkVCurwcU6B4LAKpJB6wCEkb51HnMVFBuoPo6EXGz08OyBksLzinT.8rX8v1";

    shell = pkgs.bash;

  };
}
