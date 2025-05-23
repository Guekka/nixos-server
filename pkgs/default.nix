{pkgs}: {
  beepertexts = pkgs.callPackage ./beeper-beta.nix {};
  clight-gui = pkgs.callPackage ./clight-gui {};
  cozy-stack = pkgs.callPackage ./cozy-stack {};
  iopaint = pkgs.callPackage ./iopaint {};
  rembg = pkgs.callPackage ./rembg {};
  scenedetect = pkgs.callPackage ./scenedetect {};
  tcount = pkgs.callPackage ./tcount {};
}
