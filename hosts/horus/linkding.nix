{config, ...}: let
  dataDir = "/var/lib/linkding";
  port = 11452;
in {
  virtualisation.oci-containers.containers.linkding = {
    image = "docker.io/sissbruecker/linkding:latest";
    volumes = [
      "${dataDir}:/etc/linkding/data"
    ];
    ports = ["${toString port}:9090"];
    environment = {
      LD_CONTAINER_NAME = "linkding";
      LD_HOST_PORT = "9090";
      LD_SUPERUSER_NAME = "admin";
      LD_SUPERUSER_PASSWORD = "admin";
      LD_DISABLE_BACKGROUND_TASKS = "False";
      LD_DISABLE_URL_VALIDATION = "False";
      LD_ENABLE_AUTH_PROXY = "False";
    };
    environmentFiles = [config.sops.secrets.linkdingEnv.path];
  };

  services.nginx.virtualHosts."links.bizel.fr" = {
    http3 = true;

    useACMEHost = "bizel.fr";
    forceSSL = true;

    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://localhost:${toString port}";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = dataDir;
        mode = "0750";
        user = "root";
        group = "root";
      }
    ];
  };

  sops.secrets.linkdingEnv = {
    sopsFile = ./secrets.yaml;
  };
}
