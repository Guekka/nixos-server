{
  lib,
  pkgs,
  ...
}: {
  xdg = {
    mime.enable = true;
    mimeApps.enable = true;
    userDirs.enable = true;

    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
    };
  };

  # Thank you, xdg-ninja. Not thank you, applications that don't respect XDG.
  home.sessionVariables = {
    GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    GTK2_RC_FILES = lib.mkForce "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    KDEHOME = "$XDG_CONFIG_HOME/kde";
    LESSHISTFILE = "$XDG_DATA_HOME/less/history";
    XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/compose";
    MPLAYER_HOME = "$XDG_CONFIG_HOME/mplayer";
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    SONARLINT_USER_HOME = "$XDG_DATA_HOME/sonarlint";
    WINEPREFIX = "$XDG_DATA_HOME/wine";
  };
}
