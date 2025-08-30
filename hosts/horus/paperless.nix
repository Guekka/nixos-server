{
  config,
  pkgs,
  ...
}: let
  port = 53214;
  virtualHost = "paperless.bizel.fr";

  postConsumeScript = pkgs.writeShellScript "post-consume.sh" ''
    # paperless sets new files as 700, we want them to be 750 so that nextcloud can read them
    # we process all files just in case, it's very fast anyway
    chmod -R 750 ${config.services.paperless.mediaDir}
  '';

  # systemd service has restricted file access, so we need to copy the script to a location where it can be executed
  postConsumeScriptPath = "${config.services.paperless.dataDir}/post-consume.sh";
in {
  services.paperless = {
    enable = true;
    settings = {
      PAPERLESS_URL = "https://${virtualHost}";
      PAPERLESS_OCR_LANGUAGE = "fra+eng";
      PAPERLESS_OCR_USER_ARGS = ''
        {
          "invalidate_digital_signatures": true
        }
      '';
      PAPERLESS_DBENGINE = "postgresql";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBPORT = "5432";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";
      PAPERLESS_CONSUMER_RECURSIVE = true;
      PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
      PAPERLESS_FILENAME_FORMAT = "{{ owner_username }}/{{ document_type }}/{{ correspondent }}/{{ created_year }} - {{ title }}";
      PAPERLESS_FILENAME_FORMAT_REMOVE_NONE = true;
      PAPERLESS_POST_CONSUME_SCRIPT = postConsumeScriptPath;
    };
    inherit port;
    passwordFile = config.sops.secrets.paperless.path;
    consumptionDir = "/shared/edgar/documents/paperless";
    consumptionDirIsPublic = true;
  };

  # make the script accessible by paperless
  systemd.tmpfiles.rules = [
    "L+ ${postConsumeScriptPath} - - - - ${postConsumeScript}"
  ];

  services.nginx.virtualHosts."${virtualHost}" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${toString port}";
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = config.services.paperless.dataDir;
        mode = "0750";
        user = "paperless";
        group = "paperless";
      }
    ];
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "paperless";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "paperless"
    ];
  };

  sops.secrets.paperless = {
    sopsFile = ./secrets.yaml;
  };
}
