{pkgs, ...}: {
  home.packages = [
    pkgs.cinnamon.nemo-with-extensions
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nemo.desktop";
    "application/x-gnome-saved-search" = "nemo.desktop";
  };
}
