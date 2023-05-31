{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = 'Solarized (light) (terminal.sexy)',
      }
    '';
  };
}
