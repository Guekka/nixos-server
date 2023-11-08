{config, ...}: {
  services.nginx.virtualHosts."files.bizel.fr" = {
    addSSL = true;
    enableACME = true;
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
    "/persist".directories = ["/var/www/files"];
  };
}
