{
  services.sonarr = {
    enable = true;
  };

  services.nginx.virtualHosts."sonarr.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:8989";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/sonarr";
        user = "sonarr";
        group = "sonarr";
        mode = "0755";
      }
    ];
  };
}
