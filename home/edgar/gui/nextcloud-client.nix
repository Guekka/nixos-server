{config, ...}: {
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.packages = [
    config.services.nextcloud-client.package
  ];
}
