let
  port = 7852;
in {
  services.headscale = {
    enable = true;
    inherit port;
    server_url = "https://headscale.bizel.fr:${toString port}";
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/headscale";
        owner = "headscale";
        group = "headscale";
        mode = "0700";
      }
    ];
  };
}
