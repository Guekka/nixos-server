{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.wallabag;
  inherit (builtins) toJSON;
  inherit (lib) mkOption mkEnableOption types mkIf;
  wallabag = pkgs.wallabag.overrideAttrs (old: {
    patches =
      builtins.filter (patch: builtins.baseNameOf patch != "wallabag-data.patch") old.patches
      ++ [
        # https://github.com/jtojnar/nixfiles/commit/662ac88e3358e9b50468c4bbf124aa821e22cae4
        ./wallabag-data-location.patch
      ];
  });

  wallabagConfig = toJSON {
    parameters = {
      database_driver = "pdo_pgsql";
      database_host = "";
      database_port = 5432;
      database_name = "wallabag";
      database_user = "wallabag";
      database_password = "";
      database_path = "";
      database_table_prefix = "wallabag_";
      database_socket = "/run/postgresql/.s.PGSQL.5432";
      database_charset = "utf8";

      domain_name = "https://${cfg.domain}";
      server_name = "Wallabag";

      mailer_dsn = "smtp://127.0.0.1";

      locale = "en";

      "env(SECRET_FILE)" = "${cfg.secretPath}";
      secret = "test";

      twofactor_auth = true;
      twofactor_sender = "no-reply@${cfg.domain}";

      fosuser_registration = true;
      fosuser_confirmation = false;

      # how long the access token should live in seconds for the API
      fos_oauth_server_access_token_lifetime = 3600;
      # how long the refresh token should life in seconds for the API
      fos_oauth_server_refresh_token_lifetime = 1209600;

      from_email = "no-reply@${cfg.domain}";

      # rss_limit = 50;

      # RabbitMQ processing
      rabbitmq_host = "localhost";
      rabbitmq_port = config.services.rabbitmq.port;
      rabbitmq_user = "guest";
      rabbitmq_password = "guest";
      rabbitmq_prefetch_count = 10;

      # Redis processing
      redis_scheme = "unix";
      redis_host = ""; # Ignored for unix scheme
      redis_port = 0; # Ignored for unix scheme
      redis_path = config.services.redis.servers.wallabag.unixSocket;
      redis_password = null;

      # sentry logging
      sentry_dsn = null;
    };
  };

  php = pkgs.php.withExtensions ({
    enabled,
    all,
  }:
    enabled
    ++ (with all; [
      imagick
      tidy
    ]));

  wallabagServiceConfig = {
    CacheDirectory = "wallabag";
    CacheDirectoryMode = "700";

    ConfigurationDirectory = "wallabag";
    ConfigurationDirectoryMode = "700";

    LogsDirectory = "wallabag";

    StateDirectory = "wallabag";
    StateDirectoryMode = "700";
    #DynamicUser = false;
  };
in {
  options.services.wallabag = {
    enable = mkEnableOption "Enable Wallabag";
    domain = mkOption {
      type = types.str;
      description = "Domain wallabag will run on";
    };
    secretPath = mkOption {
      type = types.path;
      description = "Path to file containing the wallabag secret";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/wallabag";
      description = "wallabag data directory";
    };

    socket = mkOption {
      type = types.path;
      default = config.services.phpfpm.pools.wallabag.socket;
      description = "wallabag data directory";
    };
    user = mkOption {
      type = with types; oneOf [str int];
      default = "wallabag";
      description = "The user wallabag will run as.";
    };

    group = mkOption {
      type = with types; oneOf [str int];
      default = "wallabag";
      description = "The group wallabag will run with.";
    };
  };

  config = mkIf cfg.enable {
    # Install console manager
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "wallabag-console" ''
        export WALLABAG_DATA="${cfg.dataDir}"
        cd "${cfg.dataDir}"
        ${php}/bin/php ${wallabag}/bin/console --env=prod $@
      '')
    ];

    environment.etc."wallabag/parameters.yml" = {
      source = pkgs.writeTextFile {
        name = "wallabag-config";
        text = wallabagConfig;
      };
    };

    users.groups.${cfg.group} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      description = "Wallabag daemon user";
      home = cfg.dataDir;
      createHome = true;
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      root = "${wallabag}/web";
      extraConfig = ''
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
      '';
      locations = {
        "/".extraConfig = "try_files $uri /app.php$is_args$args;";
        "/assets".root = "${wallabag}/app/web";
        "~ ^/app\\.php(/|$)".extraConfig = ''
          fastcgi_pass unix:${cfg.socket};
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_param PATH_INFO $fastcgi_path_info;
          fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
          fastcgi_param SCRIPT_FILENAME ${wallabag}/web/$fastcgi_script_name;
          fastcgi_param DOCUMENT_ROOT ${wallabag}/web;
          fastcgi_param REMOTE_USER $remote_user;
          fastcgi_read_timeout 120;
          internal;
        '';
        "~ /(?!app)\\.php$".extraConfig = "return 404;";
      };
    };

    services.phpfpm = {
      pools.wallabag = {
        inherit (cfg) user;
        phpPackage = php;
        settings = {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          pm = "dynamic";
          "pm.max_children" = 5;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 3;
          clear_env = false;
          catch_workers_output = true;
        };
        phpOptions = ''
          ; Set up $_ENV superglobal.
          ; http://php.net/request-order
          variables_order = "EGPCS"
          # Wallabag will crash on start-up.
          # https://github.com/wallabag/wallabag/issues/6042
          error_reporting = E_ALL & ~E_USER_DEPRECATED & ~E_DEPRECATED
        '';
      };
    };

    systemd.services.phpfpm-wallabag.serviceConfig = wallabagServiceConfig;

    systemd.services.wallabag-install = {
      description = "Wallabag install service";
      wantedBy = ["multi-user.target"];
      before = ["phpfpm-wallabag.service"];
      after = ["postgresql.service"];
      path = with pkgs; [coreutils php phpPackages.composer];
      serviceConfig =
        {
          User = cfg.user;
          Restart = "always";
          RuntimeMaxSec = "10m"; # wallabag stops working every now and then. This "fixes" it
        }
        // wallabagServiceConfig;
      preStart = ''
        mkdir -p "${cfg.dataDir}/data/db"
      '';
      script = ''
        echo $(whoami)
        if [ ! -f "$STATE_DIRECTORY/installed" ]; then
          if php ${wallabag}/bin/console --env=prod wallabag:install; then
            echo "Wallabag initial config complete"
            touch "$STATE_DIRECTORY/installed"
          else
            echo "failed to install!"
            exit 1
          fi
        else
          echo "Running wallabag migrations"
          php ${wallabag}/bin/console --env=prod doctrine:migrations:migrate --no-interaction
        fi
        echo "Starting Wallabag"
        php ${wallabag}/bin/console --env=prod cache:clear
      '';
    };

    services.rabbitmq.enable = true;
    services.redis.servers.wallabag = {
      enable = true;
      user = "wallabag";
    };
  };
}
