{config, ...}: {
  services.microbin = {
    enable = true;
    passwordFile = config.sops.secrets.microbin-admin.path;
    settings = {
      MICROBIN_PORT = 9345;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_QR = true;
      MICROBIN_PUBLIC_PATH = "https://sp.bizel.fr";
      MICROBIN_EDITABLE = true;
      MICROBIN_PRIVATE = true;
    };
  };

  sops.secrets.microbin-admin.sopsFile = ./secrets.yaml;

  services.nginx.virtualHosts."sp.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:9345";
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/private/microbin";
        mode = "0700";
        user = "microbin";
        group = "microbin";
      }
    ];
  };
}
