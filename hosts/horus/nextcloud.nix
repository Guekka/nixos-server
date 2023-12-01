{
  pkgs,
  config,
  ...
}: let
  appDir = "/var/lib/nextcloud";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;

    hostName = "nc.bizel.fr";
    home = appDir;

    https = true;

    extraAppsEnable = true;
    extraApps = with pkgs.nextcloud26Packages.apps; {
      inherit calendar contacts;
    };

    config = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";

      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";

      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-pass.path;
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
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  # Ensure that postgres is running before running the setup
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  environment.persistence."/persist" = {
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
