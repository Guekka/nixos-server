let
  dataDir = "/var/lib/trilium";
  port = 42710;
in {
  services.trilium-server = {
    enable = true;
    inherit dataDir port;
  };

  services.nginx.virtualHosts."trilium.bizel.fr" = {
    locations."/".proxyPass = "http://localhost:${toString port}";
    forceSSL = true;
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "trilium";
      group = "trilium";
    }
  ];
}
