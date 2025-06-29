{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.swww];

  systemd.user.services = {
    swww = {
      Unit = {
        Description = "Efficient animated wallpaper daemon for wayland";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.swww}/bin/swww-daemon
        '';
        ExecStop = "${pkgs.swww}/bin/swww kill";
        Restart = "on-failure";
      };
    };
    default_wall = {
      Unit = {
        Description = "default wallpaper";
        Requires = ["swww.service"];
        After = ["swww.service"];
        PartOf = ["swww.service"];
      };
      Install.WantedBy = ["swww.service"];
      Service = {
        ExecStart = ''${pkgs.swww}/bin/swww img "${config.wallpaper}" --transition-type random'';
        Restart = "on-failure";
        Type = "oneshot";
      };
    };
  };
}
