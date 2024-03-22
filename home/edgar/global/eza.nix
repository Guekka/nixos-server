{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    git = true;
    extraOptions = [
      "-lg"
      "--all"
      "--header"
      "--icons"
      "--group-directories-first"
    ];
  };
}
