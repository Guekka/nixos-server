{config, ...}: {
  services.postgresql = {
    enable = true;
  };

  services.postgresqlBackup = {
    enable = true;
    compression = "zstd";
  };

  environment.persistence."/persist" = {
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
