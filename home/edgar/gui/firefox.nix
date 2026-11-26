{lib, ...}: {
  programs.firefox = {
    enable = true;
    configPath = lib.mkDefault ".mozilla/firefox"; # keep legacy default (stateVersion < 26.05)
  };

  stylix.targets.firefox.profileNames = lib.mkDefault ["default"];

  home = {
    sessionVariables.BROWSER = "firefox";
  };
  myHome.impermanence.passthrough = {
    "/persist/backup".directories = [
      ".mozilla"
    ];

    "/persist/nobackup".directories = [
      ".cache/mozilla"
    ];
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
