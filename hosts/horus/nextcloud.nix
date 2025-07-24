{
  pkgs,
  config,
  ...
}: let
  appDir = "/var/lib/nextcloud";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;

    hostName = "nc.bizel.fr";
    home = appDir;

    https = true;

    extraAppsEnable = true;
    extraApps = with pkgs.nextcloud31Packages.apps; {
      inherit bookmarks calendar contacts cospend deck forms polls tasks;
    };

    config = {
      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";

      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-pass.path;
    };

    settings = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";
    };
  };

  sops.secrets.nextcloud-pass = {
    sopsFile = ./secrets.yaml;
    owner = "nextcloud";
  };

  # Enable PostgreSQL
  services.postgresql = {
    # Ensure the database, user, and permissions always exist
    ensureDatabases = ["nextcloud"];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  # Give access to paperless files for external storage
  users.users.nextcloud.extraGroups = ["paperless"];

  # Ensure that postgres is running before running the setup
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = appDir;
        user = "nextcloud";
        group = "nextcloud";
        mode = "0700";
      }
    ];
  };
}
