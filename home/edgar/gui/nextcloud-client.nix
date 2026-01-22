{config, ...}: {
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home = {
    packages = [
      config.services.nextcloud-client.package
    ];

    persistence = {
      "/persist/backup".directories = [
        ".config/Nextcloud"
      ];

      "/persist/nobackup".directories = [
        "Nextcloud"
      ];
    };
  };
}
