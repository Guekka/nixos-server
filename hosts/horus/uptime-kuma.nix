{
  services.uptime-kuma = {
    enable = true;
  };

  services.nginx.virtualHosts."status.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/private/uptime-kuma";
        user = "uptime-kuma";
        group = "uptime-kuma";
        mode = "0755";
      }
    ];
  };

  users = {
    users.uptime-kuma = {
      isSystemUser = true;
      group = "uptime-kuma";
    };
    groups.uptime-kuma = {};
  };
}
