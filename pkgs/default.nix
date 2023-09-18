# deadnix: skip
{pkgs}: {
  csvlens = pkgs.callPackage ./csvlens {};
  image-sieve = pkgs.callPackage ./image-sieve {};
  kondo = pkgs.callPackage ./kondo {};
  tcount = pkgs.callPackage ./tcount {};
}
