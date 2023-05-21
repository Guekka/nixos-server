{config, ...}: {
  services.photoprism = {
    enable = true;
    passwordFile = config.sops.secrets.photoprismPass.path;

    originalsPath = "/shared/edgar/Pictures";
  };

  sops.secrets.photoprismPass = {
    sopsFile = ./secrets.yaml;
  };

  services.nginx.virtualHosts."photo.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://${config.services.photoprism.address}:${toString config.services.photoprism.port}";
      proxyWebsockets = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/private/photoprism";
        user = "photoprism";
        group = "photoprism";
        mode = "0755";
      }
    ];
  };
}
