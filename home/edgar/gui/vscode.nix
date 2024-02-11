{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    # i love immutability, but sometimes I want a one-time extension
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions;
      [
        arrterian.nix-env-selector
        github.copilot
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        ms-vscode.cpptools
        ms-vscode.makefile-tools
        rust-lang.rust-analyzer
        pkief.material-icon-theme
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "aw-watcher-vscode";
          publisher = "activitywatch";
          version = "0.5.0";
          sha256 = "sha256-OrdIhgNXpEbLXYVJAx/jpt2c6Qa5jf8FNxqrbu5FfFs=";
        }
        {
          name = "vscode-xml";
          publisher = "redhat";
          version = "0.26.0";
          sha256 = "sha256-QAy+h3SS5DIuPwyoqt80TL1M3bQNxg2+/uacUzdlp/U=";
        }
      ];

    userSettings = {
      "cmake.configureOnOpen" = true;

      "editor.formatOnSave" = true;

      # Indent
      "editor.detectIndentation" = false;
      "editor.indentSize" = 4;
      "editor.insertSpaces" = true;
      "editor.tabSize" = 4;

      "editor.inlineSuggest.enabled" = true;

      # Font
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Fira Code";

      "editor.unicodeHighlight.nonBasicASCII" = false;

      "explorer.confirmDragAndDrop" = false;

      "files.eol" = "\n";
      "files.exclude" = {
        "**/.devenv" = true;
        "**/.direnv" = true;
      };
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;

      "git.autofetch" = true;
      "git.confirmSync" = false;

      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = true;
        "markdown" = true;
      };

      "workbench.colorTheme" = "Solarized Light";
      "workbench.iconTheme" = "material-icon-theme";

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
      "nix.serverSettings" = {
        "nil.formatting.command" = ["${pkgs.alejandra}/bin/alejandra"];
      };

      "python.analysis.typeCheckingMode" = "strict";

      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.checkOnSave" = true;
    };
  };
}
