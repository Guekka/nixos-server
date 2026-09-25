{config, ...}: let
  dataDir = "/var/lib/grist";
  port = 8484;
  domain = "grist.bizel.fr";
in {
  virtualisation.oci-containers.containers.grist = {
    # No services.grist NixOS module exists yet
    image = "gristlabs/grist:1.7.19";
    autoStart = true;
    ports = ["127.0.0.1:${toString port}:${toString port}"];
    volumes = [
      "${dataDir}:/persist"
    ];
    environment = {
      TZ = config.time.timeZone;
      APP_ROOT_URL = "https://${domain}";
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    useACMEHost = "bizel.fr";
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "root";
      group = "root";
      mode = "0750";
    }
  ];
}
