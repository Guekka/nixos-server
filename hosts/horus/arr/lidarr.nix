{
  services.lidarr = {
    enable = true;
  };

  services.nginx.virtualHosts."lidarr.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:8686";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/lidarr";
        user = "lidarr";
        group = "lidarr";
        mode = "0755";
      }
    ];
  };
}
