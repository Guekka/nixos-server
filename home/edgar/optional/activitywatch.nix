{pkgs, ...}: {
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      awatcher.package = pkgs.awatcher;
    };
  };

  # from <https://github.com/jordanisaacs/dotfiles/blob/20d6ff59e1a468b9ce5d78fcf169b31c977bd1b9/modules/users/applications/activitywatch.nix#L4>
  # awatcher should start and stop depending on WM session target
  # starting activitywatch should only start awatcher if the WM is active
  systemd.user.services.activitywatch-watcher-awatcher = let
    target = "hyprland-session.target";
  in {
    Unit = {
      After = [target];
      Requisite = [target];
      PartOf = [target];
    };
    Install = {WantedBy = [target];};
  };
}
