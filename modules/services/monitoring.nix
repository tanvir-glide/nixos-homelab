{config, pkgs, ... }:

{
  # Grafana
  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
    };
  };  

  services.prometheus = {
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

  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
  };


}
