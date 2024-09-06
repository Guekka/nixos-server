{config, ...}: {
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
  };

  environment.persistence."/persist" = {
    directories = [config.services.grocy.dataDir];
  };
}
