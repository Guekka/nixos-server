{
  config,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
  };

  services.postgresqlBackup = {
    enable = true;
    compression = "zstd";
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "0750";
      }
      {
        directory = config.services.postgresqlBackup.location;
        user = "postgres";
        group = "postgres";
        mode = "0750";
      }
    ];
  };
}
