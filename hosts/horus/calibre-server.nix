{
  lib,
  pkgs,
  ...
}: let
  library = "/shared/edgar/books";
in {
  services = {
    calibre-server = {
      enable = true;
      libraries = [library];
    };
    calibre-web = {
      # TODO enable = true; build failure
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        calibreLibrary = library;
      };
    };
  };

  services.nginx.virtualHosts."calibre.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:8080"; # TODO change to 8083 once web enabled
    };
  };

  # TODO: upstream that
  systemd.services.calibre-server.serviceConfig.ExecStart = lib.mkForce "${pkgs.calibre}/bin/calibre-server ${library} --enable-auth";

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/calibre-server";
        mode = "0750";
        user = "calibre-server";
        group = "calibre-server";
      }
      {
        directory = "/var/lib/calibre-web";
        mode = "0750";
        user = "calibre-web";
        group = "calibre-web";
      }
    ];
  };
}
