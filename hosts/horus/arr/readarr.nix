{
  services.readarr = {
    enable = true;
  };

  services.nginx.virtualHosts."readarr.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:8787";
    };
  };

  environment.persistence."/persist" = {
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
