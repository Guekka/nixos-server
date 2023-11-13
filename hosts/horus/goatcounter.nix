{pkgs, ...}: {
  systemd.services.goatcounter = {
    wantedBy = ["multi-user.target"];
    enable = true;

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "2s";
      ExecStart = ''
        ${pkgs.goatcounter}/bin/goatcounter \
          serve \
          -automigrate \
          -listen localhost:3004 \
          -tls none \
          -db 'postgresql+host=/run/postgresql dbname=goatcounter sslmode=disable' \
      '';
      User = "goatcounter";
    };
  };

  services.nginx.virtualHosts."goatcounter.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:3004";
      proxyWebsockets = true;
    };
  };

  environment.systemPackages = [
    pkgs.goatcounter
  ];

  services.postgresql.ensureDatabases = ["goatcounter"];
  services.postgresql.ensureUsers = [
    {
      name = "goatcounter";
      ensurePermissions."DATABASE goatcounter" = "ALL PRIVILEGES";
    }
  ];

  users.users.goatcounter = {
    isSystemUser = true;
    group = "goatcounter";
  };
  users.groups.goatcounter = {};
}
