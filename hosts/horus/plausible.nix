{config, ...}: {
  services.plausible = {
    enable = true;

    releaseCookiePath = config.sops.secrets.plausibleCookiePath.path;

    server = {
      baseUrl = "https://plausible.bizel.fr";
      port = 4004;
      secretKeybaseFile = config.sops.secrets.plausibleKey.path;
    };

    adminUser = {
      activate = true;
      email = "trucmuche909@gmail.com";
      passwordFile = config.sops.secrets.plausibleAdmin.path;
    };
  };

  services.nginx.virtualHosts."plausible.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString config.services.plausible.server.port}";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/clickhouse";
        mode = "0750";
        user = "clickhouse";
        group = "clickhouse";
      }
      {
        directory = "/var/lib/private/plausible";
        mode = "0750";
        user = "plausible";
        group = "plausible";
      }
    ];
  };

  sops.secrets = {
    plausibleAdmin = {
      sopsFile = ./secrets.yaml;
    };
    plausibleKey = {
      sopsFile = ./secrets.yaml;
    };
    plausibleCookiePath = {
      sopsFile = ./secrets.yaml;
    };
  };
}
