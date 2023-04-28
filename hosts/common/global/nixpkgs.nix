{overlays, ...}: {
  nixpkgs = {
    overlays = builtins.attrValues overlays;
    config = {
      allowUnfree = true;
    };
  };
}
