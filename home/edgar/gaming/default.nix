{pkgs, ...}: {
  imports = [
    ./heroic.nix
  ];

  home = {
    packages = with pkgs; [
      lutris
    ];

    persistence = {
      "/persist/backup/home/edgar".directories = [
        ".config/lutris"
      ];

      "/persist/nobackup/home/edgar".directories = [
        ".local/share/lutris"
      ];
    };
  };
}
