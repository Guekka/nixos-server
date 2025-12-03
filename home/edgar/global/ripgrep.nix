{pkgs, ...}: {
  programs.ripgrep = {
    enable = true;
    arguments = ["-S"]; # smart case
  };

  home.packages = [
    pkgs.ripgrep-all
  ];
}
