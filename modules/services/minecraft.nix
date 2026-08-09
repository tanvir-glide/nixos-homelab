{
  config,
  pkgs,
  ...
}: {
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = pkgs.papermcServers.papermc-1_21_10;

    serverProperties = {
      server-ip = "";
      server-port = 46565;
      difficulty = "normal";
      gamemode = "survival";
      max-players = 4;

      sync-chunk-writes = false;

      online-mode = false;
    };
  };
}
