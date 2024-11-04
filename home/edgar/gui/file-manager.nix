{pkgs, ...}: {
  home.packages = [
    pkgs.stable.cinnamon.nemo-with-extensions
  ];
}
