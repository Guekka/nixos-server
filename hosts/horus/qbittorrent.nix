let
  uid = 9876;
  gid = 9877;
in {
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "dyonr/qbittorrentvpn";
    ports = ["127.0.0.1:8080:8080"];
    extraOptions = ["--privileged"];
    volumes = [
      "/etc/wireguard/:/config/wireguard/"
      "/var/lib/qbittorrent:/config"
      "/shared/downloads:/downloads"
    ];
    environment = {
      VPN_ENABLED = "yes";
      VPN_TYPE = "wireguard";
      LAN_NETWORK = "192.168.1.0/24";
      ENABLE_SSL = "no";
      PUID = toString uid;
      PGID = toString gid;
    };
  };

  services.nginx.virtualHosts."torrent.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:8080";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/qbittorrent";
        user = "qbittorrent";
        group = "qbittorrent";
        mode = "0750";
      }
      {
        directory = "/etc/wireguard";
        user = "root";
        group = "root";
        mode = "0750";
      }
    ];
  };

  users = {
    users.qbittorrent = {
      inherit uid;
      group = "qbittorrent";
      isSystemUser = true;
    };
    groups.qbittorrent = {
      inherit gid;
    };
  };
}
