{
  config,
  pkgs,
  lib,
  ...
}:

{
  # grafana key encrypted
  age.secrets.grafana-key = {
    file = ../../secrets/grafana-key.age;
    owner = "grafana";
    group = "grafana";
  };

  # Grafana & Prompetheus combo
  services = {
    grafana = {
      enable = true;

      settings.security.secret_key = "$__env{GRAFANA_SECRET_KEY}";

      settings.server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
      };
    };

    prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "localhost:9100" ];
            }
          ];
        }
      ];
    };

    prometheus.exporters.node = {
      enable = true;
      port = 9100;
    };
  };
  systemd.services.grafana.serviceConfig.EnvironmentFile = config.age.secrets.grafana-key.path;
}
