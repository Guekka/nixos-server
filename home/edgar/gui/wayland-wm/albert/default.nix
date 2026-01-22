{
  config,
  pkgs,
  ...
}: {
  home = {
    # used by plugins
    sessionVariables."GOLDENDICT_FORCE_WAYLAND" = "1";
    packages = [pkgs.goldendict-ng pkgs.libnotify];

    persistence."/persist/nobackup".directories = [
      ".cache/albert"
      ".local/share/albert"
    ];
  };

  services.albert.enable = true;

  xdg.configFile = let
    dir = "/home/edgar/nixos/home/edgar/gui/wayland-wm/albert/";
  in {
    # out of store while still in the learning phase
    "albert/config".source = config.lib.file.mkOutOfStoreSymlink "${dir}/config";
    "albert/websearch/engines.json".source = config.lib.file.mkOutOfStoreSymlink "${dir}/websearch-engines.json";
  };
}
