{pkgs}: {
  awatcher = pkgs.callPackage ./awatcher {};
  clight-gui = pkgs.stable.callPackage ./clight-gui {};
  cozy-stack = pkgs.stable.callPackage ./cozy-stack {};
  image-sieve = pkgs.stable.callPackage ./image-sieve {};
  tcount = pkgs.stable.callPackage ./tcount {};
}
