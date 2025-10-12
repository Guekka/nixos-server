{inputs, ...}: let
  baseUrl = "sharry.bizel.fr";
  port = 47129;
in {
  imports = [inputs.sharry.nixosModules.default];

  services.sharry = {
    enable = true;
    config = {
      base-url = "https://${baseUrl}";
      bind.port = port;
    };
  };

  services.nginx.virtualHosts.${baseUrl} = {
    useACMEHost = "bizel.fr";
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString port}";
    };
  };

  environment.persistence."/persist/nobackup".directories = [
    {
      directory = "/var/lib/private/tandoor-recipes";
      user = "tandoor_recipes";
      group = "tandoor_recipes";
    }
  ];
}
