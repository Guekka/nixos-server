{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
      recolor-keephue = true;
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
