let
  uid = 9876;
  gid = 9877;
in {
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "dyonr/qbittorrentvpn";
    ports = ["127.0.0.1:8081:8080"];
    extraOptions = ["--cap-add=NET_ADMIN"];
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
      RESTART_CONTAINER = "no";
    };
  };

  services.nginx.virtualHosts."torrent.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://localhost:8081";
    };
  };

  environment.persistence."/persist/backup" = {
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
