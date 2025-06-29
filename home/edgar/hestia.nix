{
  imports = [
    ./optional/activitywatch.nix

    ./gaming
    ./global
    ./gui
  ];

  wallpaper = ./gui/background21.png;

  monitors = [
    {
      name = "DP-1";
      width = 3440;
      height = 1440;
      refreshRate = 144.0;
      x = 0;
      workspace = "1";
      primary = true;
      vrr = true;
      hdr = true;
    }
  ];
}
