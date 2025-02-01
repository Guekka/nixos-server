{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  home.persistence."/persist/backup/home/edgar".directories = [
    ".local/share/zoxide"
  ];
}
