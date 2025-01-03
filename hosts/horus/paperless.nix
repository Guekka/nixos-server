{config, ...}: let
  port = 53214;
  virtualHost = "paperless.bizel.fr";
in {
  services.paperless = {
    enable = true;
    settings = {
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
    };
    inherit port;
    passwordFile = config.sops.secrets.paperless.path;
    consumptionDir = "/shared/edgar/documents/paperless";
    consumptionDirIsPublic = true;
  };

  services.nginx.virtualHosts."${virtualHost}" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${toString port}";
  };

  environment.persistence."/persist" = {
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
