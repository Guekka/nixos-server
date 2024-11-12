{pkgs, ...}: {
  systemd.user.timers.shutdown_warning = {
    description = "Shutdown warning";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 22:50:00";
      Unit = "shutdown_warning.service";
    };
  };

  systemd.user.services.shutdown_warning = {
    description = "Shutdown warning";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.libnotify}/bin/notify-send 'Shutdown warning' 'The system will be shut down in 15 minutes'";
    };
  };

  systemd.timers.shutdown_schedule = {
    description = "Shutdown schedule";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 23:05:00";
      Unit = "shutdown_schedule.service";
    };
  };

  systemd.services.shutdown_schedule = {
    description = "Shutdown schedule";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl poweroff";
    };
  };
}
