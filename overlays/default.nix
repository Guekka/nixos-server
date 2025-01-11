{inputs, ...}: {
  # my packages
  additions = final: _prev:
    import ../pkgs {pkgs = final;};

  modifications = final: prev: let
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  in {
    inherit unstable;

    # required for some games
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

    helix-latest = inputs.helix.packages.${prev.system}.helix;

    # btrfs-progs 6.12 for recursive subvolume deletion
    inherit (unstable) btrfs-progs;
  };
}
