{config, ...}: {
  services.grocy = {
    enable = true;
    hostName = "grocy.bizel.fr";

    settings = {
      currency = "EUR";
      culture = "fr";
    };
  };

  environment.persistence."/persist" = {
    directories = [config.services.grocy.dataDir];
  };
}
