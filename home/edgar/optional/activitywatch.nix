{pkgs, ...}: {
  home.packages = [pkgs.awatcher pkgs.activitywatch];
  systemd.user.targets.activitywatch = {
    Unit = {
      Description = "ActivityWatch server";
      Requires = ["default.target"];
      After = ["default.target"];
    };

    Install.WantedBy = ["default.target"];
  };
  systemd.user.services = let
    baseSettings = {
      Restart = "on-failure";

      # Some sandboxing.
      LockPersonality = true;
      NoNewPrivileges = true;
      RestrictNamespaces = true;
    };
  in {
    activitywatch = {
      Unit = {
        Description = "ActivityWatch time tracker server";
        Documentation = ["https://docs.activitywatch.net"];
        BindsTo = ["activitywatch.target"];
      };

      Service =
        {
          ExecStart = "${pkgs.aw-server-rust}/bin/aw-server";
        }
        // baseSettings;

      Install.WantedBy = ["activitywatch.target"];
    };

    awatcher = {
      Unit = {
        Description = "awatcher";
        After = ["activitywatch.service"];
        BindsTo = ["activitywatch.target"];
      };

      Service =
        {
          ExecStart = "${pkgs.awatcher}/bin/awatcher";
        }
        // baseSettings;

      Install.WantedBy = ["activitywatch.target"];
    };
  };
}
