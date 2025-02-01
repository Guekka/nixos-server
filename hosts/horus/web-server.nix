{config, ...}: {
  services.nginx.virtualHosts."files.bizel.fr" = {
    forceSSL = true;
    useACMEHost = "bizel.fr";
    root = "/var/www/files";

    locations."/private/" = {
      basicAuthFile = config.sops.secrets.webServerPrivatePass.path;
    };
  };

  sops.secrets.webServerPrivatePass = {
    sopsFile = ./secrets.yaml;
    owner = "nginx";
    group = "nginx";
  };

  environment.persistence = {
    "/persist/backup".directories = ["/var/www/files"];
  };
}
