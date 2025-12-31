{config, ...}: let
  port = "8000";
  dataDir = "/var/lib/yamtrack";
  domain = "track.bizel.fr";
in {
  services.nginx.virtualHosts.${domain} = {
    locations."/" = {
      proxyPass = "http://localhost:${port}";
      proxyWebsockets = true;
    };
  };

  virtualisation.oci-containers.containers.yamtrack = {
    # fork with a few more features
    image = "ghcr.io/dannyvfilms/yamtrack:0.24.9-2";
    volumes = [
      "${dataDir}:/yamtrack/db"
    ];
    extraOptions = [
      # allow access to local redis
      "--network=host"
    ];
    environmentFiles = [
      config.sops.secrets.yamtrack.path
    ];
    environment = {
      TZ = config.time.timeZone;
      REDIS_URL = "redis://localhost:6379";
      URLS = "https://${domain}";
    };
  };

  services.redis.enable = true;

  sops.secrets.yamtrack.sopsFile = ../secrets.yaml;

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = dataDir;
        mode = "0700";
      }
    ];
  };
}
