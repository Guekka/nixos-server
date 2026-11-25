{
  config,
  inputs,
  pkgs,
  ...
}: let
  baseUrl = "sharry.bizel.fr";
  port = 47129;
in {
  imports = [inputs.sharry.nixosModules.default];

  services.sharry = {
    enable = true;
    package = inputs.sharry.packages.${pkgs.stdenv.hostPlatform.system}.sharry;
    configOverridesFile = config.sops.secrets.sharry-config.path;
    config = {
      base-url = "https://${baseUrl}";
      bind = {
        address = "127.0.0.1";
        inherit port;
      };
      backend.jdbc.url = "jdbc:h2:///var/lib/sharry/sharry.db;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE";
    };
  };

  systemd.services.sharry.serviceConfig = {
    StateDirectory = "sharry";
    StateDirectoryMode = "0700";
  };

  services.nginx.virtualHosts.${baseUrl} = {
    useACMEHost = "bizel.fr";
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };

  environment.persistence."/persist/nobackup".directories = [
    {
      directory = "/var/lib/sharry";
      user = "sharry";
      group = "sharry";
      mode = "0700";
    }
  ];

  sops.secrets.sharry-config = {
    sopsFile = ../../horus/secrets.yaml;
    owner = "sharry";
  };
}
