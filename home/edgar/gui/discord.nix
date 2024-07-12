{pkgs, ...}: {
  home.packages = [
    pkgs.vesktop
  ];

  home.sessionVariables."DISCORD_USER_DATA_DIR" = "/home/edgar/.local/share/discord";
}
