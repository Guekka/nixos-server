{pkgs, ...}: {
  services.activitywatch = {
    enable = true;
    watchers = {
      aw-watcher-afk.package = pkgs.activitywatch;
      aw-watcher-window-wayland.package = pkgs.aw-watcher-window-wayland;
    };
  };
}
