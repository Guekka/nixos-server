# deadnix: skip
{pkgs}: {
  csvlens = pkgs.callPackage ./csvlens {};
  image-sieve = pkgs.callPackage ./image-sieve {};
  tcount = pkgs.callPackage ./tcount {};
}
