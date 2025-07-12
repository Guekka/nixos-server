{pkgs}: {
  clight-gui = pkgs.callPackage ./clight-gui {};
  cozy-stack = pkgs.callPackage ./cozy-stack {};
  iopaint = pkgs.callPackage ./iopaint {};
  kobo-readstat = pkgs.callPackage ./kobo-readstat {};
  rembg = pkgs.callPackage ./rembg {};
  scenedetect = pkgs.callPackage ./scenedetect {};
  tcount = pkgs.callPackage ./tcount {};
}
