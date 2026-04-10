{ config, pkgs, lib, ... }:

{
  # System state and timezone
  system.stateVersion = "25.11";
  time.timeZone = "Asia/Dhaka";

  # Bootloader
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        };
      };

    kernelModules = [ "ntfs3" ];
    };

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

  # Hardware optimization
  services.auto-cpufreq.enable = true;

  # Making sure closing the laptop lid doesn't put it to sleep
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };
  };

  # Zram for memory efficiency
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;  # Use half of RAM for zram
}
