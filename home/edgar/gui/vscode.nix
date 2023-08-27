{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        ms-vscode.cpptools
        github.copilot
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "aw-watcher-vscode";
          publisher = "activitywatch";
          version = "0.5.0";
          sha256 = "sha256-OrdIhgNXpEbLXYVJAx/jpt2c6Qa5jf8FNxqrbu5FfFs=";
        }
      ];

    userSettings = {
      cmake = {
        configureOnOpen = true;
      };
      editor = {
        formatOnSave = true;

        # Indent
        detectIndentation = false;
        indent_style = "space";
        indentSize = 4;
        insertSpaces = true;
        tabSize = 4;

        inlineSuggest.enabled = true;

        # Font
        fontLigatures = true;
        fontFamily = "Fira Code";

        unicodeHighlight.nonBasicASCII = false;
      };
      explorer = {
        confirmDragAndDrop = false;
      };
      files = {
        eol = "\n";
        exclude = {
          "**/.devenv" = true;
          "**/.direnv" = true;
        };
        insertFinalNewLine = true;
        trimTrailingWhitespace = true;
      };
      git = {
        autofetch = true;
        confirmSync = false;
      };
      github = {
        copilot.enable = {
          "*" = true;
        };
      };
      workbench = {
        colorTheme = "Solarized Light";
        iconTheme = "ayu";
      };
      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nil}/bin/nil";
        formatterPath = "${pkgs.alejandra}/bin/alejandra";
        serverSettings = {
          nil = {
            formatting = {command = ["alejandra"];};
          };
        };
      };
    };
  };
}
