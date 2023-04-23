{overlays, ...}: {
  nixpkgs = {
    inherit overlays;
    config = {
      allowUnfree = true;
    };
  };
}
