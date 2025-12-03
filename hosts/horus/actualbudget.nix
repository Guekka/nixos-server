let
  dataDir = "/var/lib/actualbudget";
  port = 3750;
  version = "25.12.0";
in {
  users.users.actualbudget = {
    group = "actualbudget";
    isSystemUser = true;
  };
  users.groups.actualbudget = {};

  virtualisation.oci-containers.containers.actualbudget = {
    autoStart = true;
    image = "ghcr.io/actualbudget/actual-server:${version}";
    ports = ["${toString port}:5006"];
    volumes = ["${dataDir}/:/data"];
  };

  services.nginx.virtualHosts."actual.bizel.fr" = {
    locations."/".proxyPass = "http://localhost:${toString port}";
    forceSSL = true;
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "actualbudget";
      group = "actualbudget";
    }
  ];
}
