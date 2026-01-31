# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Making sure closing the laptop lid doesn't put it to sleep
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];


  # Set your time zone.
  time.timeZone = "Asia/Dhaka";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tanvir = {
    isNormalUser = true;
    description = "Tanvir";
    extraGroups = [ "networkmanager" "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6KaudWVwILSHjzNOCF3RDH27uiJOTlRXzkpVbeHvAf mac -> hp"
    ];

    packages = with pkgs; [
    git
    fastfetch
    fzf
    btop
    pfetch-rs
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  wget
  rsync
  mosh
  tailscale
  auto-cpufreq
  docker-compose
  ];

  # Enabling vim to be default EDITOR
  programs.vim.enable = true;
  programs.vim.defaultEditor = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = "yes";
      KbdInteractiveAuthentication = false;
   };
  };

  # Enabling intel microcode
  hardware.cpu.intel.updateMicrocode = true;

  # Some shell aliases
  environment.shellAliases = {
    nix-switch = "sudo nixos-rebuild switch";
    nix-clean = "sudo nix-collect-garbage -d";
    nix-conf = "sudoedit /etc/nixos/configuration.nix";

    neofetch = "clear ; fastfetch";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable=false

  # Enable firewall with necessary ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 2222 4533 5030 50300 ];
    allowedUDPPorts = [ 50300 ];
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
  };

  # Enable docker
  virtualisation.docker = {
  enable = true;
  rootless = {
    enable = true;
    setSocketVariable = true;
    };
  };

  # Enable tailscale daemon
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-dns=false" ];

  # Mounting my other ntfs drives
  fileSystems."/mnt/Files" = {
    device = "/dev/disk/by-uuid/01D858C886F164A0";
    fsType = "ntfs3";
    options = [ "defaults" "uid=1000" "gid=1000" "umask=022" "nofail" "noauto" "force" "x-systemd.automount" ];
  };

  # Enabling Zram
  zramSwap.enable = true;

  # Settings up garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  # Automatic update at 4am
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "04:00";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
