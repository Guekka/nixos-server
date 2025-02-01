{
  services.readarr = {
    enable = true;
  };

  services.nginx.virtualHosts."readarr.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:8787";
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/readarr";
        user = "readarr";
        group = "readarr";
        mode = "0755";
      }
    ];
  };
}
