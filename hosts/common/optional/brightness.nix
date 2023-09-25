{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.ddcutil
  ];

  hardware.i2c.enable = true;

  # fix https://github.com/NixOS/nixpkgs/issues/210856
  services.udev.extraRules =
    builtins.readFile
    "${pkgs.ddcutil}/share/ddcutil/data/45-ddcutil-i2c.rules";

  services.clight = {
    enable = false;
    settings = {
      verbose = false;
      resumedelay = 0;
      backlight = {
        disabled = false;
        restore_on_exit = false;
        no_smooth_transition = true;
        trans_step = 0.05;
        trans_timeout = 30;
        trans_fixed = 0;
        no_auto_calibration = false;
        pause_on_lid_closed = false;
        capture_on_lid_opened = true;
        shutter_threshold = 0.0;
        hotplug_delay = 0;
        ac_timeouts = [600 2700 300];
        batt_timeouts = [1200 5400 600];
      };
      sensor = {
        captures = [5 5];
        ac_regression_points = [0.0 0.15 0.29 0.45 0.61 0.74 0.81 0.88 0.93 0.97 1.0];
        batt_regression_points = [0.0 0.15 0.23 0.36 0.52 0.59 0.65 0.71 0.75 0.78 0.8];
      };
      keyboard = {
        disabled = false;
        ac_regression_points = [1.0 0.97 0.93 0.88 0.81 0.74 0.61 0.45 0.29 0.15 0.0];
        batt_regression_points = [0.8 0.78 0.75 0.71 0.65 0.59 0.52 0.36 0.23 0.15 0.0];
        timeouts = [15 5];
      };
      gamma = {
        disabled = false;
        restore_on_exit = false;
        no_smooth_transition = false;
        trans_step = 50;
        trans_timeout = 300;
        long_transition = false;
        ambient_gamma = false;
        temp = [6500 4000];
      };
      daytime = {
        event_duration = 1800;
        sunrise_offset = 0;
        sunset_offset = 0;
        sunrise = "";
        sunset = "";
      };
      dimmer = {
        disabled = false;
        no_smooth_transition = [false false];
        trans_steps = [0.2 0.2];
        trans_timeouts = [10 10];
        trans_fixed = [0 0];
        dimmed_pct = 0.2;
        timeouts = [45 20];
      };
      dpms = {
        disabled = false;
        timeouts = [900 300];
      };
      screen = {
        disabled = false;
        content = 0.2;
        timeouts = [5 (-1)];
      };
      inhibit = {
        disabled = false;
        inhibit_docked = false;
        inhibit_pm = false;
        inhibit_bl = false;
      };
    };
  };

  location.provider = "geoclue2";
}
