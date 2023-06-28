{inputs, ...}: {
  # my packages
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
    # fixes an issue with drag and drop
    keepassxc = prev.keepassxc.overrideAttrs (_old: {
      postFixup = ''wrapProgram $out/bin/keepassxc --set QT_QPA_PLATFORM wayland'';
    });
    steam = prev.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          dotnet-runtime
        ];
    };
  };

  jetbrains = inputs.jetbrains-updater.overlay;
}
