{pkgs}: {
  clight-gui = pkgs.callPackage ./clight-gui {};
  cozy-stack = pkgs.callPackage ./cozy-stack {};
  rembg = pkgs.callPackage ./rembg {};
  scenedetect = pkgs.callPackage ./scenedetect {};
  tcount = pkgs.callPackage ./tcount {};
}
