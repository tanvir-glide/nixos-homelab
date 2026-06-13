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
    ];

    shell = pkgs.bash;

  };
}
