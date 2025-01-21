{pkgs, ...}: {
  imports = [
    ./heroic.nix
  ];

  home.packages = with pkgs; [
    lutris
  ];
}
