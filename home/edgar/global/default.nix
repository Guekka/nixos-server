{config, ...}: {
  home = {
    username = "edgar";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "22.11";
  };
}
