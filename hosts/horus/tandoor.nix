{config, ...}: {
  services.tandoor-recipes = {
    enable = true;
    port = 7453;
  };

  services.nginx.virtualHosts."tandoor.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString config.services.tandoor-recipes.port}";
    };
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = "/var/lib/private/tandoor-recipes";
      user = "tandoor_recipes";
      group = "tandoor_recipes";
    }
  ];
}
