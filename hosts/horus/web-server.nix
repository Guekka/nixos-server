{
  services.nginx.virtualHosts."e1.oze.li" = {
    addSSL = true;
    enableACME = true;
    root = "/var/www/files";
  };

  environment.persistence = {
    "/persist".directories = ["/var/www/files"];
  };
}
