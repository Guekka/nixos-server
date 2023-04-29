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
      scrollback_pager_history_size = 128;
      window_padding_width = 15;
    };
    theme = "Solarized Light";
  };
}
