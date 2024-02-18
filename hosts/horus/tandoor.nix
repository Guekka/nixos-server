{
  config,
  pkgs,
  ...
}: {
  services.tandoor-recipes = {
    enable = true;
    package = pkgs.stable.tandoor-recipes; # unstable doesn't build
    port = 7453;
    #address = "tandoor.bizel.fr";
  };

  services.nginx.virtualHosts."tandoor.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString config.services.tandoor-recipes.port}";
    };
  };

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/private/tandoor-recipes";
      user = "tandoor_recipes";
      group = "tandoor_recipes";
    }
  ];
}
