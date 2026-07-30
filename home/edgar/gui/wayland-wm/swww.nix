{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.awww];

  systemd.user.services = {
    awww = {
      Unit = {
        Description = "Efficient animated wallpaper daemon for wayland";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.awww}/bin/awww-daemon
        '';
        ExecStop = "${pkgs.awww}/bin/awww kill";
        Restart = "on-failure";
      };
    };
    default_wall = {
      Unit = {
        Description = "default wallpaper";
        Requires = ["awww.service"];
        After = ["awww.service"];
        PartOf = ["awww.service"];
      };
      Install.WantedBy = ["awww.service"];
      Service = {
        ExecStart = ''${pkgs.awww}/bin/awww img "${config.wallpaper}" --transition-type random'';
        Restart = "on-failure";
        Type = "oneshot";
      };
    };
  };
}
