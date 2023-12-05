{
  services.bazarr = {
    enable = true;
  };

  services.nginx.virtualHosts."bazarr.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:6767";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/bazarr";
        user = "bazarr";
        group = "bazarr";
        mode = "0755";
      }
    ];
  };
}
