{config, ...}: {
  programs.bash.historyFile = "${config.xdg.stateHome}/bash_history";
}
