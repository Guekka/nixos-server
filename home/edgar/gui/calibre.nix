{pkgs, ...}: {
  home.packages = [
    pkgs.calibre
    pkgs.mozjpeg # for jpeg transformation
    pkgs.optipng
  ];
}
