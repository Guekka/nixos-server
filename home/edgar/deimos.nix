{
  imports = [
    ./optional/activitywatch.nix
    ./optional/eduroam.nix

    ./gaming
    ./global
    ./gui
  ];

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];
}
