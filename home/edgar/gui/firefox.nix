{
  programs.firefox = {
    enable = true;
  };

  home = {
    persistence = {
      "/persist/backup/home/edgar".directories = [
        ".mozilla"
      ];

      "/persist/nobackup/home/edgar".directories = [
        ".cache/mozilla"
      ];
    };

    sessionVariables.BROWSER = "firefox";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };
  };
}
