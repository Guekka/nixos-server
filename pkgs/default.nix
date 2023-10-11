# deadnix: skip
{pkgs}: {
  clight-gui = pkgs.callPackage ./clight-gui {};
  csvlens = pkgs.callPackage ./csvlens {};
  image-sieve = pkgs.callPackage ./image-sieve {};
  kondo = pkgs.callPackage ./kondo {};
  plex-desktop = pkgs.callPackage ./plex-desktop {};
  qt6gtk2 = pkgs.qt6Packages.callPackage ./qt6gtk2 {};
  unsilence = pkgs.callPackage ./unsilence {};
  tcount = pkgs.callPackage ./tcount {};
}
