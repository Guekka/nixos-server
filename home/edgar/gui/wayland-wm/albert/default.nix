{pkgs, ...}: {
  home = {
    # used by plugins
    sessionVariables."GOLDENDICT_FORCE_WAYLAND" = "1";
    packages = [pkgs.goldendict-ng pkgs.libnotify];
  };
  myHome.impermanence.passthrough."/persist/nobackup".directories = [
    ".cache/albert"
    ".local/share/albert"
  ];

  services.albert.enable = true;

  xdg.configFile = {
    "albert/config".source = ./config;
    "albert/websearch/engines.json".source = ./websearch-engines.json;
  };
}
