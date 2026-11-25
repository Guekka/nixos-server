{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.nonNixos;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.ydotool];
    home.sessionVariables.YDOTOOL_SOCKET = "$XDG_RUNTIME_DIR/ydotool.socket";

    systemd.user.services.ydotoold = {
      Unit = {
        Description = "ydotoold - backend for ydotool";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe' pkgs.ydotool "ydotoold"} --socket-path=%t/ydotool.socket --socket-perm=0600";
        Restart = "on-failure";
      };
    };

    xdg.configFile = {
      "ydotool/80-uinput.rules".text = ''
        SUBSYSTEM=="misc", KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';
      "ydotool/uinput.conf".text = ''
        uinput
      '';
    };
  };
}
