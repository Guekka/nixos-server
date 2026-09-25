{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs_22,
  turbo,
  makeWrapper,
  writableTmpDirAsHomeHook,
  nix-update-script,
}: let
  pname = "gram";
  version = "1.0.1";
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version;

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "gram-lang";
      repo = "gram";
      rev = "3d29949b76fc722265e34d8df46eaaea06a3808a";
      hash = "sha256-JC5M2NdFJg2gT+O6d/wAf/Uu/V08USxEd9Q0J+0GK2c=";
    };

    node_modules = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ [
          "GIT_PROXY_COMMAND"
          "SOCKS_SERVER"
        ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;
      dontFixup = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install \
          --cpu="*" \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="*"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;

        runHook postInstall
      '';

      outputHash = "sha256-84nLtHBUjZ5a0Zv4RBZwIEGIx+qXEDCFUptsHk/jZYc=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };

    nativeBuildInputs = [
      bun
      nodejs_22
      turbo
      makeWrapper
    ];

    configurePhase = ''
      runHook preConfigure

      cp -R ${finalAttrs.node_modules}/. .
      mkdir -p .nix-bin
      cat > .nix-bin/tsup <<'EOF'
      #!/bin/sh
      if [ -x ./node_modules/.bin/tsup ]; then
        exec ./node_modules/.bin/tsup "$@"
      fi

      if [ -x ../../node_modules/.bin/tsup ]; then
        exec ../../node_modules/.bin/tsup "$@"
      fi

      exec ${bun}/bin/bun x tsup "$@"
      EOF
      chmod +x .nix-bin/tsup
      export PATH="$PWD/.nix-bin:$PATH"
      patchShebangs .

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      turbo run build --filter=@gram-lang/cli...

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/${pname}
      install -Dm644 packages/cli/package.json $out/lib/${pname}/package.json
      cp -R packages/cli/dist $out/lib/${pname}/

      # Keep runtime dependencies adjacent to dist/index.js so Node ESM resolution works.
      cp -R node_modules $out/lib/${pname}/

      # Workspace package links in node_modules resolve into ../../packages/*.
      mkdir -p $out/lib/${pname}/packages
      for pkg in analyzer format i18n kitchen parser renderer; do
        mkdir -p "$out/lib/${pname}/packages/$pkg"
        cp -R "packages/$pkg/dist" "$out/lib/${pname}/packages/$pkg/"
        cp "packages/$pkg/package.json" "$out/lib/${pname}/packages/$pkg/"
      done

      # Keep workspace symlink targets present to satisfy Nix broken symlink checks.
      mkdir -p \
        $out/lib/${pname}/audit \
        $out/lib/${pname}/conformance \
        $out/lib/${pname}/packages/cli \
        $out/lib/${pname}/packages/docs \
        $out/lib/${pname}/packages/language-server \
        $out/lib/${pname}/packages/vscode-extension
      cp packages/cli/package.json $out/lib/${pname}/packages/cli/

      makeWrapper ${nodejs_22}/bin/node $out/bin/gram \
        --add-flags $out/lib/${pname}/dist/index.js

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };

    meta = {
      description = "CLI for the Gram recipe language";
      homepage = "https://github.com/gram-lang/gram";
      changelog = "https://github.com/gram-lang/gram/blob/${finalAttrs.src.rev}/CHANGELOG.md";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "gram";
      platforms = lib.platforms.all;
    };
  })
