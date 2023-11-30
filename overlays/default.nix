{inputs, ...}: {
  # my packages
  additions = final: prev:
    import ../pkgs {pkgs = final;}
    // {
      vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins {};
    };

  modifications = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
    # fixes an issue with drag and drop
    keepassxc = prev.keepassxc.overrideAttrs (_old: {
      postFixup = ''wrapProgram $out/bin/keepassxc --set QT_QPA_PLATFORM wayland'';
    });
    # fixes discocss for 0.0.28
    discocss = prev.discocss.overrideAttrs (_old: {
      version = "0.0.28";
      src = final.fetchFromGitHub {
        owner = "bddvlpr";
        repo = "discocss";
        rev = "610302e25a420b8cd6f08b8faff909685d2f79fd";
        sha256 = "sha256-2K7SPTvORzgZ1ZiCtS5TOShuAnmtI5NYkdQPRXIBP/I=";
      };
    });
    steam = prev.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          dotnet-runtime
        ];
    };
  };
}
