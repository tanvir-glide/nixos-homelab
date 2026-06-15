{
  config,
  pkgs,
  lib,
  ...
}:

{
  age.secrets.ntfy-topic = {
    file = ../../secrets/ntfy-topic.age;
    owner = "root";
  };
}
