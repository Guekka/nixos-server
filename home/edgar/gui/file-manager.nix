{pkgs, ...}: {
  home.packages = [
    pkgs.libsForQt5.dolphin
    pkgs.libsForQt5.dolphin-plugins
  ];

  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/file" = "org.kde.dolphin.desktop";
      "x-directory/normal" = "org.kde.dolphin.desktop";
    };

    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
      "x-directory/normal" = "org.kde.dolphin.desktop";
      "x-scheme-handler/file" = "org.kde.dolphin.desktop";
    };
  };
}
