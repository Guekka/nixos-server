{config, ...}: let
  dataDir = "/var/lib/mathesar";
  port = 51378;
  version = "0.2.1";
  domain = "mathesar.bizel.fr";
in {
  users.users.mathesar = {
    group = "mathesar";
    isSystemUser = true;
  };
  users.groups.mathesar = {};

  virtualisation.oci-containers.containers.mathesar = {
    autoStart = true;
    image = "docker.io/mathesar/mathesar:${version}";
    environment = {
      DJANGO_SETTINGS_MODULE = "config.settings.production";
      ALLOWED_HOSTS = "*";
      DEBUG = "false";
      SECRET_KEY = config.sops.secrets.mathesar-secret.path;
      DOMAIN_NAME = "https://${domain}";
    };
    environmentFiles = [
      config.sops.secrets.mathesar-env.path
    ];

    ports = ["${toString port}:8000"];
    volumes = [
      "${dataDir}/static:/code/static"
      "${dataDir}/media:/code/media"
    ];
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "mathesar";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "mathesar_django"
    ];
  };

  services.nginx.virtualHosts.${domain} = {
    locations."/".proxyPass = "http://localhost:${toString port}";
    forceSSL = true;
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "mathesar";
      group = "mathesar";
    }
  ];

  sops.secrets.mathesar-env.sopsFile = ../secrets.yaml;
}
