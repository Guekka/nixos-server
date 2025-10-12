{config, ...}: {
  services.gokapi = {
    enable = true;
    environment = {
      GOKAPI_PORT = 59325;
    };
  };

  services.nginx.virtualHosts."gokapi.bizel.fr" = {
    useACMEHost = "bizel.fr";
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString config.services.gokapi.environment.GOKAPI_PORT}";
    };
  };

  environment.persistence."/persist/nobackup".directories = [
    {
      directory = "/var/lib/gokapi";
      user = "gokapi";
      group = "gokapi";
    }
  ];
}
