{inputs, ...}: {
  # my packages
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  jetbrains = inputs.jetbrains-updater.overlay;
}
