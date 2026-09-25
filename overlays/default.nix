{inputs, ...}: {
  # my packages
  additions = final: _prev:
    import ../pkgs {pkgs = final;};

  inherit (inputs.niri.overlays) niri;

  modifications = final: prev: let
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  in {
    inherit unstable;

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

    helix-latest = inputs.helix.packages.${prev.stdenv.hostPlatform.system}.helix;

    sweethome3d.application = prev.sweethome3d.application.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "NaharEmet";
        repo = "sweethome3d-7.5-wayland-patch";
        rev = "v7.5-fixed";
        hash = "sha256-8sLJTtpvzSgWlJNVPnAbyYGRhDyBqGIUR8ptyNG8xp0=";
      };

      postFixup =
        (old.postFixup or "")
        + ''
          substituteInPlace $out/bin/sweethome3d \
            --replace \
              "-Dsun.java2d.opengl=true" \
              "-Dsun.java2d.opengl=false"
        '';
    });
  };
}
