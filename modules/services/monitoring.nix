{
  config,
  pkgs,
  vars,
  ...
}: {
  services.beszel = {
    # ---------------- Hub (The Dashboard) ----------------
    hub = {
      enable = true;
      port = 8090;
    };

    # ---------------- Agent (The Metrics Collector) ----------------
    agent = {
      enable = true;
      # Internal metrics port defaults to 45876

      environment = {
        PORT = "45876";
        # PASTE YOUR BESZEL HUB PUBLIC KEY HERE AFTER INITIAL SETUP
        KEY = "";
      };
    };
  };
}
