{
  services = {
    calibre-web = {
      enable = true;
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        enableKepubify = true;

        calibreLibrary = "/shared/edgar/books";
      };
    };
  };

  # TODO upstream
  systemd.services.calibre-web.environment = {
    CACHE_DIR = "/var/lib/calibre-web/cache";
  };

  services.nginx.virtualHosts."calibre.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://[::1]:8083";
      extraConfig = ''
        # fix kobo sync
        proxy_busy_buffers_size   1024k;
        proxy_buffers   4 512k;
        proxy_buffer_size   1024k;

        # allow large books
        client_body_in_file_only clean;
        client_body_buffer_size 32K;

        client_max_body_size 300M;

        sendfile on;
        send_timeout 300s;
      '';
    };
  };
  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/calibre-web";
        mode = "0750";
        user = "calibre-web";
        group = "calibre-web";
      }
    ];
  };
}
