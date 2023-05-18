{
  virtualisation.oci-containers.containers.microbin = {
    image = "danielszabo99/microbin";
    ports = ["9345:8080"];
    volumes = [
      "/var/lib/microbin:/app/pasta_data"
    ];
    cmd = [
      "--editable"
      "--enable-burn-after"
      "--private"
      "--qr"
      "--highlightsyntax"
      "--default-expiry"
      "24hour"
      "--public-path"
      "https://sp.bizel.fr"
    ];
  };

  services.nginx.virtualHosts."sp.bizel.fr" = {
    enableACME = true;
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:9345";
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/microbin";
        mode = "0700";
      }
    ];
  };
}
