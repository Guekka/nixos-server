{
  programs.exa = {
    enable = true;
    enableAliases = true;
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
