{
  programs.firefox = {
    enable = true;
    configPath = ".config/mozilla/firefox";
    profiles = {
      default = {
        id = 1;
        path = "pw0bxc7h.default";
        isDefault = true;
      };
      default-release = {
        id = 0;
        path = "3olwdi2k.default-release";
        isDefault = false;
      };
    };
  };

  stylix.targets.firefox.profileNames = [
    "default"
    "default-release"
  ];

  home = {
    sessionVariables.BROWSER = "firefox";
  };
  myHome.impermanence.passthrough = {
    "/persist/backup".directories = [
      ".config/mozilla/firefox"
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
