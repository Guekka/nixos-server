let
  dataDir = "/var/lib/actualbudget";
  port = 3750;
  version = "24.11.0";
in {
  users.users.actualbudget = {
    group = "actualbudget";
    isSystemUser = true;
  };
  users.groups.actualbudget = {};

  virtualisation.oci-containers.containers.actualbudget = {
    autoStart = true;
    environment = {
      # See all options and more details at
      # https://actualbudget.github.io/docs/Installing/Configuration
      # ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = 20;
      # ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB = 50;
      # ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = 20;
    };
    image = "ghcr.io/actualbudget/actual-server:${version}";
    ports = ["${toString port}:5006"];
    volumes = ["${dataDir}/:/data"];
  };

  services.nginx.virtualHosts."actual.bizel.fr" = {
    locations."/".proxyPass = "http://localhost:${toString port}";
    forceSSL = true;
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist".directories = [
    {
      directory = dataDir;
      user = "actualbudget";
      group = "actualbudget";
    }
  ];
}
