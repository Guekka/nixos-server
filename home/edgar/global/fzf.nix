{config, ...}: {
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    defaultOptions = with config.colorscheme.colors; [
      # https://github.com/sagikazarmark/nix-config/blob/f1380179eae6082e6383fe071982c458041cda85/modules/home-manager/modules/nix-colors/programs/fzf.nix
      "--color=bg+:#${base01},bg:#${base00},spinner:#${base0C},hl:#${base0D}"
      "--color=fg:#${base04},header:#${base0D},info:#${base0A},pointer:#${base0C}"
      "--color=marker:#${base0C},fg+:#${base06},prompt:#${base0A},hl+:#${base0D}"
    ];
  };
}
