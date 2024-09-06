{config, ...}: {
  services.netdata = {
    enable = true;
  };

  services.nginx.virtualHosts."netdata.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:19999";
      basicAuthFile = config.sops.secrets.netdataPassword.path;
    };
  };

  sops.secrets.netdataPassword = {
    sopsFile = ./secrets.yaml;
    owner = config.services.netdata.user;
    inherit (config.services.netdata) group;
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
