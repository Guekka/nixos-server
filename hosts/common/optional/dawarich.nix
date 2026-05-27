{lib, ...}: let
  dataDir = "/var/lib/dawarich";
  port = 51763;
  domain = "location.bizel.fr";
in {
  services.dawarich = {
    enable = true;
    webPort = port;
    localDomain = domain;
    environment = {
      PHOTON_API_HOST = "photon.komoot.io";
      PHOTON_API_USE_HTTPS = "true";
      APPLICATION_PROTOCOL = "http";
    };
  };
  services.nginx.virtualHosts.${domain}.locations."@proxy" = {
    proxyPass = "http://127.0.0.1:51763";

    # ❌ disable this (this is the root of your issue)
    recommendedProxySettings = lib.mkForce false;

    proxyWebsockets = true;

    extraConfig = ''
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;

      # ✅ correct headers
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

      # 🔥 THE IMPORTANT ONE
      proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
    '';
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "dawarich";
      group = "dawarich";
    }
  ];
}
