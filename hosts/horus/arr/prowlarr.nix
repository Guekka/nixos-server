{
  services.prowlarr = {
    enable = true;
  };

  services.nginx.virtualHosts."prowlarr.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:9696";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/private/prowlarr";
        user = "prowlarr";
        group = "prowlarr";
        mode = "0755";
      }
    ];
  };

  users.users.prowlarr = {
    group = "prowlarr";
    isSystemUser = true;
  };
  users.groups.prowlarr = {};
}
