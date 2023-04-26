# See https://discourse.nixos.org/t/black-screen-when-resuming-from-suspend/10299/2
{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_6_2;
}
