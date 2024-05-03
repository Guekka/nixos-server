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
    steam = prev.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          dotnet-runtime
        ];
    };

    # some tweaks to staruml
    staruml = prev.staruml.overrideAttrs (_old: {
      postFixup = let
        asar = "${prev.asar}/bin/asar";
        jq = "${prev.jq}/bin/jq";
      in ''
        # extract $out/opt/StarUML/resources/app.asar
        ${asar} extract $out/opt/StarUML/resources/app.asar $out/tmp

        ${jq} '.config.setappBuild = true' $out/tmp/package.json > $out/tmp/package.json.new
        mv $out/tmp/package.json.new $out/tmp/package.json

        rm $out/opt/StarUML/resources/app.asar
        ${asar} pack $out/tmp $out/opt/StarUML/resources/app.asar

        # cleanup
        rm -rf $out/tmp
      '';
    });
  };
}
