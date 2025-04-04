{config, ...}: {
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/shared/edgar/music";
    };
  };

  services.nginx.virtualHosts."navidrome.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://${config.services.navidrome.settings.Address}:${toString config.services.navidrome.settings.Port}";
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/private/navidrome";
        mode = "0755";
        user = "navidrome";
        group = "navidrome";
      }
    ];
  };
}
