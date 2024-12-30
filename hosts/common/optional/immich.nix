{
  config,
  lib,
  ...
}: {
  services.nginx.virtualHosts."immich.bizel.fr" = {
    extraConfig = ''
      ## Per https://immich.app/docs/administration/reverse-proxy...
      client_max_body_size 50000M;
    '';
    useACMEHost = "bizel.fr";

    locations."/" = {
      proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}";
      proxyWebsockets = true;
    };
  };

  services.immich = {
    enable = true;
  };

  # reduce hardening to allow hardware acceleration
  systemd.services.immich-server.serviceConfig = {
    PrivateDevices = lib.mkForce false;
    DeviceAllow = "/dev/dri/renderD128 rwm";
  };

  environment.persistence."/persist".directories = [
    {
      directory = config.services.immich.mediaLocation;
      user = "immich";
      group = "immich";
      mode = "0750";
    }
  ];

  # TODO
  /*
  services.borgmatic.configurations.default.exclude_patterns = [
    # The immich database is dumped, no need to backup the live data
    "/persist/${immichAppdataRoot}"
    # Expensive to compute, but can be regenerated
    "/persist/${immichPhotosWithoutLibrary}"
  ];
  */
}
