{
  pkgs,
  system,
}: let
  x86Only = builtins.elem system ["i686-linux" "x86_64-linux"];
in
  {
    clight-gui = pkgs.callPackage ./clight-gui {};
    cozy-stack = pkgs.callPackage ./cozy-stack {};
    gram = pkgs.callPackage ./gram {};
    iopaint = pkgs.callPackage ./iopaint {};
    kobo-readstat = pkgs.callPackage ./kobo-readstat {};
    rembg = pkgs.callPackage ./rembg {};
    scenedetect = pkgs.callPackage ./scenedetect {};
    tcount = pkgs.callPackage ./tcount {};
  }
  // (
    if x86Only
    then {
      pantum-universal-driver = pkgs.callPackage ./pantum-universal-driver {};
    }
    else {}
  )
