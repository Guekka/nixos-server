{pkgs}: {
  awatcher = pkgs.callPackage ./awatcher {};
  clight-gui = pkgs.callPackage ./clight-gui {};
  cozy-stack = pkgs.callPackage ./cozy-stack {};
  image-sieve = pkgs.callPackage ./image-sieve {};
  tcount = pkgs.callPackage ./tcount {};
}
