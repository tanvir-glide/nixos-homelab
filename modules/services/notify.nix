{
  config,
  pkgs,
  ...
}:

let
  apprise = "${pkgs.apprise}/bin/apprise";
  cfg = "--config /etc/apprise/ntfy.cfg";
in

{
  system.activationScripts.apprise-config = {
    deps = [ "agenix" ];
    text = ''
      mkdir -p /etc/apprise
      echo "ntfys://ntfy.sh/$(cat ${config.age.secrets.ntfy-topic.path})" > /etc/apprise/ntfy.cfg
      chmod 600 /etc/apprise/ntfy.cfg
    '';
  };

  # Auto-upgrade Notification
  systemd = {
    services = {
      ntfy-upgrade-success = {
        description = "Notify on successful NixOS upgrade";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${apprise} -t 'NixOS Upgrade Successful' -b 'Upgrade completed on %H' ${cfg}";
        };
      };

      ntfy-upgrade-failure = {
        description = "Notify on failed NixOS upgrade";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${apprise} -t 'NixOS Upgrade Failed' -b 'Check: journalctl -u nixos-upgrade on %H' ${cfg}";
        };
      };

      nixos-upgrade = {
        onSuccess = [ "ntfy-upgrade-success.service" ];
        onFailure = [ "ntfy-upgrade-failure.service" ];
      };

    };
  };

  # Server Reboot Notification
  systemd.services.ntfy-reboot = {
    description = "Notify on system boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${apprise} -t 'Server Online' -b '%H came back online' ${cfg}";
    };
  };

  # SSH login alert
  security.pam.services.sshd.rules.session.ntfy-ssh = {
    order = 10000;
    control = "optional";
    modulePath = "${pkgs.pam}/lib/security/pam_exec.so";
    args = [ "/etc/ssh-notify" ];
  };

  environment.etc."ssh-notify" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      [ "$PAM_TYPE" = "open_session" ] || exit 0
      ${pkgs.apprise}/bin/apprise \
        -t "SSH Login" \
        -b "User: $PAM_USER | From: $PAM_RHOST" \
        --config /etc/apprise/ntfy.cfg
    '';
  };

  # SSH Failed login alert
  environment.etc."fail2ban/action.d/apprise.conf" = {
    text = ''
      [Definition]
      actionban = ${pkgs.apprise}/bin/apprise -t "SSH Banned" -b "Banned <ip> on <name>" --config /etc/apprise/ntfy.cfg
    '';
  };

  services.fail2ban.jails.sshd.settings.action = "apprise";

  # Service crash watchdog (template unit)
  systemd.services."ntfy-service-crash@" = {
    description = "Notify when a service crashes";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${apprise} -t 'Service Crashed' -b '%i failed on %H' ${cfg}";
    };
  };

  # Attach crash watcher to native and podman services
  systemd.services.navidrome.onFailure = [ "ntfy-service-crash@navidrome.service" ];
  systemd.services.minecraft-server.onFailure = [ "ntfy-service-crash@minecraft-server.service" ];
  systemd.services.grafana.onFailure = [ "ntfy-service-crash@grafana.service" ];
  systemd.services.prometheus.onFailure = [ "ntfy-service-crash@prometheus.service" ];
  systemd.services."podman-slskd".onFailure = [ "ntfy-service-crash@podman-slskd.service" ];
  systemd.services."podman-qbittorrent".onFailure = [
    "ntfy-service-crash@podman-qbittorrent.service"
  ];
}
