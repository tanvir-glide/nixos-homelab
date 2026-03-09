{config, pkgs, lib, ... }:

{
  # Grafana & Prompetheus combo
  services = {
    grafana = {
      enable = true;
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
}
