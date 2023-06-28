{
  services.netdata = {
    enable = true;
  };

  services.nginx.virtualHosts."netdata.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:19999";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/netdata";
        user = "netdata";
        group = "netdata";
        mode = "0755";
      }
    ];
  };
}
