{pkgs}: {
  clight-gui = pkgs.callPackage ./clight-gui {};
  cozy-stack = pkgs.callPackage ./cozy-stack {};
  scenedetect = pkgs.callPackage ./scenedetect {};
  image-sieve = pkgs.callPackage ./image-sieve {};
  tcount = pkgs.callPackage ./tcount {};
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./xdg-desktop-portal-termfilechooser {};
}
