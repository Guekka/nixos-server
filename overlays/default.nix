{
  nixpkgs-unstable,
  packages,
  ...
}: {
  # my packages
  additions = final: prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    unstable = import nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
