{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  home.persistence."/persist/backup".directories = [
    ".local/share/zoxide"
  ];
}
