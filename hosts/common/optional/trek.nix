let
  dataDir = "/var/lib/trek";
  port = 40173;
  domain = "trek.bizel.fr";
in {
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root - -"
    "d ${dataDir}/data 0755 root root - -"
    "d ${dataDir}/uploads 0755 root root - -"
    "d ${dataDir}/uploads/files 0755 root root - -"
    "d ${dataDir}/uploads/covers 0755 root root - -"
    "d ${dataDir}/uploads/avatars 0755 root root - -"
    "d ${dataDir}/uploads/photos 0755 root root - -"
  ];

  virtualisation.oci-containers.containers.trek = {
    image = "mauriceboe/trek:3.1.2";
    autoStart = true;
    ports = ["127.0.0.1:${toString port}:3000"];
    volumes = [
      "${dataDir}/data:/app/data"
      "${dataDir}/uploads:/app/uploads"
    ];
    environment = {
      NODE_ENV = "production";
      TZ = "UTC";
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    useACMEHost = "bizel.fr";
    forceSSL = false;
    locations."^~ /" = {
      proxyPass = "http://localhost:${toString port}";
    };
  };

  environment.persistence."/persist/backup".directories = [
    {
      directory = dataDir;
      user = "root";
      group = "root";
      mode = "0750";
    }
  ];
}
