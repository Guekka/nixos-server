{
  pkgs,
  lib,
  ...
}: {
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      awatcher.package = pkgs.awatcher;
      aw-sync.package = pkgs.aw-server-rust;
    };
  };
  systemd.user.services = {
    # from <https://github.com/jordanisaacs/dotfiles/blob/20d6ff59e1a468b9ce5d78fcf169b31c977bd1b9/modules/users/applications/activitywatch.nix#L4>
    # awatcher should start and stop depending on WM session target
    # starting activitywatch should only start awatcher if the WM is active
    activitywatch-watcher-awatcher = let
      target = "graphical-session.target";
    in {
      Unit = {
        After = [target];
        Requisite = [target];
        PartOf = [target];
      };
      Install = {WantedBy = [target];};
    };

    # Set sync dir
    activitywatch-watcher-aw-sync.Service.ExecStart = let
      exe = lib.getExe' pkgs.aw-server-rust "aw-sync";
      sync_dir = "/home/edgar/Nextcloud/edgar/activitywatch";
    in
      lib.mkForce "${exe} --sync-dir ${sync_dir}";
  };

  home.persistence."/persist/backup/home/edgar".directories = [
    ".local/share/activitywatch"
  ];
}
