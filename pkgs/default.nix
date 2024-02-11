{pkgs}: let
  gfm = pkgs.callPackage ./gfm {};
in {
  awatcher = pkgs.callPackage ./awatcher {};
  clight-gui = pkgs.callPackage ./clight-gui {};
  cozy-stack = pkgs.callPackage ./cozy-stack {};
  csvlens = pkgs.callPackage ./csvlens {};
  goatcounter = pkgs.callPackage ./goatcounter {};
  image-sieve = pkgs.callPackage ./image-sieve {};
  kondo = pkgs.callPackage ./kondo {};
  lan-mouse = pkgs.callPackage ./lan-mouse {};
  plex-desktop = pkgs.callPackage ./plex-desktop {};
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2 {};
  unsilence = pkgs.callPackage ./unsilence {};
  tcount = pkgs.callPackage ./tcount {};
  tilp = pkgs.callPackage ./tilp {inherit gfm;};
}
