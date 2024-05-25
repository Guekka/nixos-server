{config, ...}: let
  inherit (config.colorscheme) palette;
in {
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "${config.fontProfiles.regular.family} 12";
      recolor = true;
      default-bg = "#${palette.base00}";
      default-fg = "#${palette.base01}";
      statusbar-bg = "#${palette.base02}";
      statusbar-fg = "#${palette.base04}";
      inputbar-bg = "#${palette.base00}";
      inputbar-fg = "#${palette.base07}";
      notification-bg = "#${palette.base00}";
      notification-fg = "#${palette.base07}";
      notification-error-bg = "#${palette.base00}";
      notification-error-fg = "#${palette.base08}";
      notification-warning-bg = "#${palette.base00}";
      notification-warning-fg = "#${palette.base08}";
      highlight-color = "#${palette.base0A}";
      highlight-active-color = "#${palette.base0D}";
      completion-bg = "#${palette.base01}";
      completion-fg = "#${palette.base05}";
      recolor-lightcolor = "#${palette.base00}";
      recolor-darkcolor = "#${palette.base06}";
    };
    extraConfig = ''
      # Smooth scroll
      map h feedkeys '<C-Left>'
      map j feedkeys '<C-Down>'
      map k feedkeys '<C-Up>'
      map l feedkeys '<C-Right>'

      # zoom
      map = zoom in
      map + zoom
    '';
  };

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
