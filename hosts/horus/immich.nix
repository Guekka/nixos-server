{config, ...}: let
  immichHost = "immich.bizel.fr";

  immichRoot = "/var/lib/immich";
  immichPhotosWithoutLibrary = "${immichRoot}/photos";
  # The original photos are accessible at /shared/edgar/immich/library
  immichLibrary = "/shared/edgar/immich/library";
  immichAppdataRoot = "${immichRoot}/appdata";
  immichVersion = "v1.107.2";

  postgresRoot = "${immichAppdataRoot}/pgsql";
  postgresUser = "immich";
  postgresDb = "immich";

  immichDatabaseDumps = "/var/backup/immich/db_dumps";
in {
  services.nginx.virtualHosts."${immichHost}" = {
    extraConfig = ''
      ## Per https://immich.app/docs/administration/reverse-proxy...
      client_max_body_size 50000M;
    '';
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
    };
  };

  # Based on <https://gist.github.com/mfenniak/c6f6b1cde07fc33df4d925e13f7d5afa>
  # The primary source for this configuration is the recommended docker-compose installation of immich from
  # https://immich.app/docs/install/docker-compose, which linkes to:
  # - https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
  # - https://github.com/immich-app/immich/releases/latest/download/example.env
  # and has been transposed into nixos configuration here.  Those upstream files should probably be checked
  # for serious changes if there are any upgrade problems here.
  #
  # After initial deployment, these in-process configurations need to be done:
  # - create an admin user by accessing the site
  # - login with the admin user
  # - set the "Machine Learning Settings" > "URL" to http://immich_machine_learning:3003

  virtualisation.oci-containers.containers = {
    immich_server = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      ports = ["127.0.0.1:2283:3001"];
      extraOptions = [
        "--pull=newer"
        # Force DNS resolution to only be the podman dnsname name server; by default podman provides a resolv.conf
        # that includes both this server and the upstream system server, causing resolutions of other pod names
        # to be inconsistent.
        "--dns=10.88.0.1"
      ];
      environment = {
        IMMICH_VERSION = immichVersion;
        DB_HOSTNAME = "immich_postgres";
        DB_USERNAME = postgresUser;
        DB_DATABASE_NAME = postgresDb;
        REDIS_HOSTNAME = "immich_redis";
      };
      environmentFiles = [
        config.sops.secrets.immich_postgres.path
      ];
      volumes = [
        "${immichPhotosWithoutLibrary}:/usr/src/app/upload"
        "${immichLibrary}:/usr/src/app/upload/library"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    immich_machine_learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
      extraOptions = ["--pull=newer"];
      environment = {
        IMMICH_VERSION = immichVersion;
      };
      volumes = [
        "${immichAppdataRoot}/model-cache:/cache"
      ];
    };

    immich_redis = {
      image = "registry.hub.docker.com/library/redis:6.2-alpine@sha256:84882e87b54734154586e5f8abd4dce69fe7311315e2fc6d67c29614c8de2672";
    };

    immich_postgres = {
      image = "registry.hub.docker.com/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
      environment = {
        POSTGRES_USER = postgresUser;
        POSTGRES_DB = postgresDb;
      };
      environmentFiles = [
        config.sops.secrets.immich_postgres.path
      ];
      volumes = [
        "${postgresRoot}:/var/lib/postgresql/data"
      ];
    };

    immich_db_dumper = {
      image = "prodrigestivill/postgres-backup-local:14";
      environmentFiles = [
        config.sops.secrets.immich_postgres.path
      ];
      environment = {
        POSTGRES_HOST = "immich_postgres";
        POSTGRES_CLUSTER = "TRUE";
        POSTGRES_USER = postgresUser;
        POSTGRES_DB = postgresDb;
        SCHEDULE = "@hourly";
        POSTGRES_EXTRA_OPTS = "--clean --if-exists";
        BACKUP_DIR = "/db_dumps";
        BACKUP_KEEP_DAYS = "2";
        BACKUP_KEEP_WEEKS = "1";
        BACKUP_KEEP_MONTHS = "1";
      };
      volumes = [
        "${immichDatabaseDumps}:/db_dumps"
      ];
      dependsOn = ["immich_postgres"];
    };
  };

  environment.persistence."/persist".directories = [
    {
      directory = immichRoot;
      user = "immich";
      group = "immich";
      mode = "0750";
    }
    {
      directory = immichDatabaseDumps;
      user = "immich";
      group = "immich";
      mode = "0750";
    }
  ];

  services.borgmatic.configurations.default.exclude_patterns = [
    # The immich database is dumped, no need to backup the live data
    "/persist/${immichAppdataRoot}"
    # Expensive to compute, but can be regenerated
    "/persist/${immichPhotosWithoutLibrary}"
  ];

  users = {
    groups.immich = {};
    users.immich = {
      isSystemUser = true;
      group = "immich";
    };
  };

  # Normal users should not be able to modify the immich library directly
  systemd.tmpfiles.rules = [
    "d ${immichLibrary} 0755 immich immich"
  ];

  sops.secrets.immich_postgres.sopsFile = ./secrets.yaml;
}
