{pkgs, ...}: {
  imports = [
    ./heroic.nix
  ];

  home.packages = with pkgs; [
    gamescope
    lutris
  ];
}
