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
      "/persist/backup/home/edgar".directories = [
        ".config/Nextcloud"
      ];

      "/persist/nobackup/home/edgar".directories = [
        "Nextcloud"
      ];
    };
  };
}
