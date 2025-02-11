let
  port = 7852;
in {
  services.headscale = {
    enable = true;
    inherit port;
    settings = {
      server_url = "https://headscale.bizel.fr:${toString port}";
      dns.base_domain = "guekka.fr";
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/headscale";
        user = "headscale";
        group = "headscale";
        mode = "0700";
      }
    ];
  };
}
