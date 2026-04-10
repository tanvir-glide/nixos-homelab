{ config, pkgs, ... }:

{
  # Fail2Ban to automatically ban sus IPs
  services.fail2ban = {
    enable = true;
    # Bans the IP for 1 hour after 5 failed attempts
    maxretry = 5;
    ignoreIP = [
      "127.0.0.1/8"
      "100.64.0.0/10" # This ignores my Tailscale network so I don't ban myself lmao
    ];
  };
}
