{
  pkgs,
  config,
  ...
}: let
  port = 42428;
  dataDir = "/var/lib/karakeep";
  domain = "bookmarks.bizel.fr";
in {
  services.karakeep = {
    enable = true;
    package = pkgs.karakeep;
    extraEnvironment = {
      PORT = builtins.toString port;
      DATA_DIR = dataDir;
      NEXTAUTH_URL = "https://${domain}";
      DISABLE_SIGNUPS = "true";
      DISABLE_NEW_RELEASE_CHECK = "true";
    };
    environmentFile = config.sops.secrets.karakeep-env.path;
  };

  # Command to upgrade meilisearch DB
  # systemd.services.meilisearch.serviceConfig.ExecStart = lib.mkForce "${lib.getExe pkgs.meilisearch} --config-file-path \${RUNTIME_DIRECTORY}/config.toml --experimental-dumpless-upgrade";

  sops.secrets.karakeep-env.sopsFile = ../secrets.yaml;

  services.nginx.virtualHosts.${domain} = {
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "karakeep";
      group = "karakeep";
    }
  ];
}
