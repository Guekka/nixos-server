{
  config,
  lib,
  pkgs,
  ...
}: let
  fzfColors = config.programs.fzf.colors;
in {
  # fzf parses FZF_DEFAULT_OPTS after the options file, so keep only non-theme options here.
  home.sessionVariables = {
    FZF_DEFAULT_OPTS = lib.mkForce (lib.concatStringsSep " " config.programs.fzf.defaultOptions);
    FZF_DEFAULT_OPTS_FILE = "${config.xdg.configHome}/fzf/colors";
  };
  xdg.configFile."fzf/colors".text = lib.optionalString (fzfColors != {}) ''
    --color ${lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}:${value}") fzfColors)}
  '';

  programs.fzf = let
    fdCommand = "${lib.getExe pkgs.fd} -H --type f --color=always";
  in {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    fileWidgetCommand = fdCommand;

    defaultOptions = [
      "--ansi"
    ];
  };

  # from <https://junegunn.github.io/fzf/tips/ripgrep-integration/>
  programs.fish.functions.rfv.body = ''
    set reload 'reload:rg --column --color=always --smart-case {q} || :'
    set opener '
      $EDITOR {1} +{2}     # No selection. Open the current line in the editor.
    '
    fzf --disabled --ansi --multi \
        --bind "start:$reload" --bind "change:$reload" \
        --bind "enter:execute($opener)" \
        --bind "ctrl-o:execute($opener)" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$argv"
  '';
}
