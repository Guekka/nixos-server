{config, ...}: let
  port = 14935;
in {
  services.kavita = {
    enable = true;
    tokenKeyFile = config.sops.secrets.kavita-token-key.path;
    settings = {
      Port = port;
    };
  };

  sops.secrets.kavita-token-key.sopsFile = ../secrets.yaml;

  services.nginx.virtualHosts."kavita.bizel.fr" = {
    useACMEHost = "bizel.fr";
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = config.services.kavita.dataDir;
        mode = "0750";
        user = "kavita";
        group = "kavita";
      }
    ];
  };
}
