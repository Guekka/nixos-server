{
  home = {
    sessionVariables = {
      TERMINAL = "kitty";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 15;
      # TODO investigate shell integration
    };
    keybindings = {
      "f1" = "new_tab_with_cwd";
    };
  };

  home.persistence."/persist/nobackup/home/edgar".directories = [
    ".cache/kitty"
  ];
}
