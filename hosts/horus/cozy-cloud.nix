{
  config,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    outputs.nixosModules.couchdb-extended
    outputs.nixosModules.cozy-cloud
  ];

  services.couchdb = {
    enable = true;
    adminPass = "pass";
  };

  services.couchdbExtended = {
    ensureAdminUser = {
      name = config.services.cozy-cloud.settings.couchdb.user;
      passwordFile = pkgs.writeText "cozy-couchdb-password" config.services.cozy-cloud.settings.couchdb.pass;
    };
  };

  services.cozy-cloud = {
    enable = true;
    settings = {
      port = 8439;
      adminPort = 8440;

      decryptorKeyFile = config.sops.secrets.cozyDecKey.path;
      encryptorKeyFile = config.sops.secrets.cozyEncKey.path;
      adminPasswordFile = config.sops.secrets.cozyAdminPass.path;
    };
  };

  services.nginx.virtualHosts."*.cozy.bizel.fr" = {
    serverAliases = ["cozy.bizel.fr"];
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString config.services.cozy-cloud.settings.port}";
      proxyWebsockets = true;
    };
  };

  security.acme.certs."bizel.fr".extraDomainNames = ["*.cozy.bizel.fr"];

  sops.secrets.cozyAdminPass = {
    owner = "cozy";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets.cozyDecKey = {
    owner = "cozy";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets.cozyEncKey = {
    owner = "cozy";
    sopsFile = ./secrets.yaml;
  };
}
