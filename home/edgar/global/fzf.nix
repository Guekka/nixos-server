{
  lib,
  pkgs,
  ...
}: {
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
  programs.fish.shellAliases = {
    rfv = let
      reload = "reload:rg --column --color=always --smart-case {q} || :";
      opener = ''
        if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
          vim {1} +{2}     # No selection. Open the current line in Vim.
        else
          vim +cw -q {+f}  # Build quickfix list for the selected items.
        fi
      '';
    in ''
      fzf --disabled --ansi --multi \
          --bind "start:${reload}" --bind "change:${reload}" \
          --bind "enter:become:${opener}" \
          --bind "ctrl-o:execute:${opener}" \
          --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
          --delimiter : \
          --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
          --preview-window '~4,+{2}+4/3,<80(up)' \
          --query "$argv"
    '';
  };
}
