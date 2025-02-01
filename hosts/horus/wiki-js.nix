{config, ...}: {
  services.wiki-js = {
    enable = true;
    settings = {
      port = 3897;
      db = {
        host = "/run/postgresql";
        user = "wiki-js";
        type = "postgres";
      };
    };
  };

  services.nginx.virtualHosts."wiki.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString config.services.wiki-js.settings.port}";
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/private/wiki-js";
        user = "wiki-js";
        group = "wiki-js";
      }
    ];
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "wiki-js";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "wiki-js"
    ];
  };
}
