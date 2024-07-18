{pkgs}: {
  clight-gui = pkgs.stable.callPackage ./clight-gui {};
  cozy-stack = pkgs.stable.callPackage ./cozy-stack {};
  scenedetect = pkgs.stable.callPackage ./scenedetect {};
  image-sieve = pkgs.stable.callPackage ./image-sieve {};
  tcount = pkgs.stable.callPackage ./tcount {};
  xdg-desktop-portal-termfilechooser = pkgs.stable.callPackage ./xdg-desktop-portal-termfilechooser {};
}
