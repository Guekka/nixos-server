{
  nixpkgs-unstable,
  jetbrains-updater,
  ...
}: {
  # my packages
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: _prev: {
    unstable = import nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      overlays = [jetbrains-updater.overlay];
    };
  };
}
