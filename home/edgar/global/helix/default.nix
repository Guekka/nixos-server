{
  lib,
  inputs,
  pkgs,
  ...
}: {
  programs.helix = let
    copilot = pkgs.writeShellScriptBin "copilot" ''
      exec ${pkgs.nodejs}/bin/node ${pkgs.vimPlugins.copilot-vim}/dist/language-server.js "''$@"
    '';
    helix-copilot = pkgs.writeShellApplication {
      name = "hx";
      runtimeInputs = [copilot];
      text = ''
        exec ${pkgs.helix-latest}/bin/hx -a "''$@"
      '';
    };
  in {
    enable = true;
    package = helix-copilot;
    defaultEditor = true;
    settings = {
      editor = {
        color-modes = true;
        line-number = "relative";
        indent-guides.render = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };

      keys = {
        insert = {
          "C-w" = "copilot_apply_completion";
          "C-e" = "copilot_show_completion";
        };

        normal = {
          "C-e" = "copilot_toggle_auto_render";
        };
      };
    };

    languages = {
      language = [
        {
          name = "bash";
          language-servers = ["bash-language-server" "wakatime"];
          auto-format = true;
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
            args = ["-i" "2" "-"];
          };
        }
        {
          name = "markdown";
          language-servers = ["markdown-oxide" "wakatime"];
        }
        {
          name = "typst";
          language-servers = ["tinymist" "wakatime"];
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "wakatime"];
        }
        {
          name = "cpp";
          language-servers = ["rust-analyzer" "wakatime"];
        }
        {
          name = "nix";
          language-servers = ["nil" "wakatime"];
        }
        {
          name = "typescript";
          language-servers = ["typescript-language-server" "wakatime"];
        }
      ];
      language-server = {
        tinymist.command = lib.getExe pkgs.tinymist;

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

        typescript-language-server = {
          command = lib.getExe pkgs.nodePackages.typescript-language-server;
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
