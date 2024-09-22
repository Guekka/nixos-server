let
  url = "hedgedoc.bizel.fr";
  port = 47351;
in {
  services.hedgedoc = {
    enable = true;
    settings = {
      domain = url;
      inherit port;
      protocolUseSSL = true;
      allowFreeURL = true;
      email = true;
      allowEmailRegister = true;
      allowAnonymous = true;
      allowAnonymousEdits = true;
    };
  };

  users.users.nginx.extraGroups = ["hedgedoc"];
  services.nginx.virtualHosts."${url}" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/hedgedoc";
        mode = "0700";
        user = "hedgedoc";
        group = "hedgedoc";
      }
    ];
  };
}
