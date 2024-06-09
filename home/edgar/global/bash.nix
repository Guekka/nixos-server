{config, ...}: {
  home.sessionVariables.HISTFILE = config.xdg.stateHome;
}
