{config, ...}: let
  host = "localhost:45852";
in {
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = host;
    };
    adminCredentialsFile = config.sops.secrets.minifluxEnv.path;
  };

  services.nginx.virtualHosts."rss.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."/".proxyPass = "http://${host}";
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/private/miniflux";
        mode = "0750";
        user = "miniflux";
        group = "miniflux";
      }
    ];
  };

  users.users.miniflux = {
    isSystemUser = true;
    group = "miniflux";
  };

  users.groups.miniflux = {};

  sops.secrets.minifluxEnv = {
    sopsFile = ./secrets.yaml;
  };
}
