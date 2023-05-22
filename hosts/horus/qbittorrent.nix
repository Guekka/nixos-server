{
  config,
  outputs,
  ...
}: {
  imports = [outputs.nixosModules.qbittorrent];

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."torrent.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString config.services.qbittorrent.port}";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = config.services.qbittorrent.dataDir;
        user = config.services.qbittorrent.user;
        group = config.services.qbittorrent.group;
        mode = "0700";
      }
    ];
  };
}
