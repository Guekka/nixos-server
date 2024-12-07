{config, ...}: {
  services.netdata = {
    enable = true;
  };

  services.nginx.virtualHosts."netdata.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:19999";
      basicAuthFile = config.sops.secrets.netdata-password.path;
    };
  };

  sops.secrets.netdata-password = {
    sopsFile = ../secrets.yaml;
    owner = "nginx";
    group = "nginx";
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
