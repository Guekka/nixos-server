{pkgs, ...}: {
  home = {
    packages = [
      pkgs.calibre
      pkgs.mozjpeg # for jpeg transformation
      pkgs.optipng
    ];
  };
  myHome.impermanence.passthrough."/persist/backup".directories = [
    ".config/calibre"
  ];
}
