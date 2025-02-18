{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  copilot = pkgs.writeShellScriptBin "copilot" ''
    exec ${pkgs.nodejs}/bin/node ${pkgs.vimPlugins.copilot-vim}/dist/language-server.js "''$@"
  '';
  helix-copilot = pkgs.symlinkJoin {
    name = "helix";
    paths = [
      inputs.helix.packages.${pkgs.system}.helix
    ];
    buildInputs = [pkgs.makeWrapper];
    runtimeInputs = [
      copilot
    ];
    postBuild = ''
      wrapProgram $out/bin/hx --add-flags "-a" --set PATH ${lib.makeBinPath [copilot]}
    '';
  };
  helix-single = pkgs.writeShellApplication {
    name = "hxs";
    text = ''
      exec ${pkgs.helix-latest}/bin/hx "''$@"
    '';
  };
in {
  stylix.targets.helix.enable = false;

  home.packages = [helix-single];
  programs.helix = {
    enable = true;
    package = helix-copilot;
    defaultEditor = true;
    settings = {
      theme = "solarized_${config.stylix.polarity}";

      editor = {
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 500;
          };
        };
        bufferline = "multiple";
        color-modes = true;
        line-number = "relative";
        indent-guides.render = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        lsp = {
          display-inlay-hints = true;
        };
        soft-wrap.enable = true;
        text-width = 110;
      };

      keys = {
        insert = {
          "C-w" = "copilot_apply_completion";
          "C-e" = "copilot_show_completion";
        };

        normal = {
          "C-e" = "copilot_toggle_auto_render";
          "=" = ":format"; # = is range-selection by default
        };
      };
    };

    languages = {
      language = [
        {
          name = "bash";
          language-servers = ["bash-language-server" "wakatime" "vale"];
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
            args = ["-i" "2" "-"];
          };
        }
        {
          name = "markdown";
          language-servers = ["markdown-oxide" "wakatime" "vale"];
        }
        {
          name = "typst";
          language-servers = ["tinymist" "wakatime" "vale"];
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "wakatime" "vale"];
          auto-format = true;
        }
        {
          name = "cpp";
          language-servers = ["rust-analyzer" "wakatime" "vale"];
        }
        {
          name = "nix";
          language-servers = ["nil" "wakatime" "vale"];
          auto-format = true;
        }
        {
          name = "python";
          language-id = "python";
          language-servers = ["pyright" "ruff" "wakatime"];
          formatter = {
            command = lib.getExe pkgs.ruff;
            args = ["format" "-"];
          };
          roots = ["pyproject.toml" "setup.py" "poetry.lock" ".git" ".jj" ".venv/"];
        }
        {
          name = "typescript";
          language-servers = ["typescript-language-server" "wakatime" "vale"];
        }
      ];

      language-server = {
        tinymist = {
          command = lib.getExe pkgs.tinymist;
          config = {
            formatterMode = "typstfmt";
            exportPdf = "onSave";
            formatterPrintWidth = 100;
          };
        };

        bash-language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = ["start"];
        };

        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          clangd.fallbackFlags = ["-std=c++2b"];
        };

        markdown-oxide.command = lib.getExe pkgs.markdown-oxide;

        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
        };

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
        };

        pylsp = {
          command = lib.getExe pkgs.python3Packages.python-lsp-server;
        };

        pyright = {
          command = lib.getExe' pkgs.pyright "pyright-langserver";
          args = ["--stdio"];
          config = {
            python.analysis.ignore = ["/"]; # rely on ruff
            python.analysis.typeCheckingMode = "strict";
          };
        };

        ruff = {
          command = lib.getExe pkgs.ruff;
          args = ["server"];
        };

        typescript-language-server = {
          command = lib.getExe pkgs.nodePackages.typescript-language-server;
        };

        vale = {
          command = lib.getExe pkgs.vale-ls;
        };

        vscode-css-language-server = {
          command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/css-languageserver";
          args = ["--stdio"];
        };

        wakatime.command = lib.getExe inputs.wakatime-lsp.packages.${pkgs.system}.default;
      };
    };
  };
}
