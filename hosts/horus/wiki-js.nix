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
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString config.services.wiki-js.settings.port}";
    };
  };

  environment.persistence."/persist" = {
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
        ensurePermissions = {
          "DATABASE wiki" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [
      "wiki"
    ];
  };
}
