{config, ...}: let
  dataDir = "/var/lib/tandoor-recipes";
in {
  services.tandoor-recipes = {
    enable = true;
    port = 7453;
    extraConfig = {
      # See https://docs.tandoor.dev/install/manual/#nginx
      GUNICORN_MEDIA = true;
      MEDIA_ROOT = "${dataDir}/media";
      ALLOWED_HOSTS = "tandoor.bizel.fr";
    };
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
      directory = dataDir;
      user = "tandoor_recipes";
      group = "tandoor_recipes";
    }
  ];
}
