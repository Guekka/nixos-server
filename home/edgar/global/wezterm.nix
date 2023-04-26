{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Solarized Light (base16)",
      }
    '';
  };
}
