{
  config,
  lib,
  ...
}: {
  services.grocy = {
    enable = true;
    hostName = "grocy.bizel.fr";

    settings = {
      currency = "EUR";
      culture = "fr";
    };
  };

  services.nginx.virtualHosts.${config.services.grocy.hostName} = {
    useACMEHost = "bizel.fr";
    enableACME = lib.mkForce false;
  };

  environment.persistence."/persist" = {
    directories = [config.services.grocy.dataDir];
  };
}
