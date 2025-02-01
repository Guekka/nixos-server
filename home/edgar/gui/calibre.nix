{pkgs, ...}: {
  home = {
    packages = [
      pkgs.calibre
      pkgs.mozjpeg # for jpeg transformation
      pkgs.optipng
    ];

    persistence."/persist/backup/home/edgar".directories = [
      ".config/calibre"
    ];
  };
}
