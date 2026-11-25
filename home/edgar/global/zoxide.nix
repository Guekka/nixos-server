{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  myHome.impermanence.passthrough."/persist/backup".directories = [
    ".local/share/zoxide"
  ];
}
