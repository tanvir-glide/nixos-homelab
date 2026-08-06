{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # Storage
    ./modules/hardware/storage.nix
  ];

  # sudo but written in rust, good for memory safety
  security.sudo-rs.enable = true;

  # Enabling flakes
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;

    };

    # Settings up garbage collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  services.journald.extraConfig = ''
    # Keep a maximum of 50MB of logs in memory cache
    RuntimeMaxUse=50M

    # Keep a maximum of 2G of logs on the local disk total
    SystemMaxUse=2G

    # Max time to keep a log file before rotating it
    MaxFileSec=1month
  '';

  # Some shell aliases for long commands
  environment.shellAliases = {
    nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    nix-clean = "sudo nix-collect-garbage -d";
    neofetch = "clear ; fastfetch";
  };

  # Automatic update at 4am
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "Fri 04:00";
  };
}
