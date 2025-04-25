{pkgs, ...}: {
  imports = [
    ./optional/activitywatch.nix

    ./gaming
    ./global
    ./gui
  ];

  monitors = [
    {
      name = "HDMI-A-1";
      width = 2560;
      height = 1440;
      refreshRate = 60.0;
      x = 0;
      workspace = "2";
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 144.0;
      x = 2560;
      workspace = "1";
      primary = true;
    }
  ];

  home.packages = [
    pkgs.lan-mouse
  ];
}
