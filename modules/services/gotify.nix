{ config, pkgs, lib, ... }:

let
  
  serverIP = "YOUR_SERVER_IP"; 
  appToken = "YOUR_GOTIFY_APP_TOKEN"; 

  gotify-alert = pkgs.writeShellScriptBin "gotify-alert" ''
    ${pkgs.curl}/bin/curl -s -X POST "http://${serverIP}:8085/message?token=${appToken}" \
      -F "title=$1" \
      -F "message=$2" \
      -F "priority=$3"
  '';
in

{
  # Enabling the server
  services.gotify = {
    enable = true;
    environment = {
      GOTIFY_SERVER_PORT = "8085";
      # Binding to 0.0.0.0 allows Tailscale to see the service
      GOTIFY_SERVER_LISTENADDR = "0.0.0.0";
    };
  };

  # Adding the alert script to your path
  environment.systemPackages = [ gotify-alert ];

  # Temp for service failures
  systemd.services."notify-failed@" = {
    description = "Notify Gotify on service failure for %i";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${gotify-alert}/bin/gotify-alert 'Service Failed: %i' 'The unit %i failed on $(hostname).' 8";
    };
  };

  # Notification on successful rebuild
  system.activationScripts.gotify-rebuild = {
    supportsDryActivation = false;
    text = ''
      if [ -e /run/current-system ]; then
        ${gotify-alert}/bin/gotify-alert "NixOS Rebuild" "System built successfully!" 5
      fi
    '';
  };
}
