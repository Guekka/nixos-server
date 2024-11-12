{pkgs, ...}: {
  i18n.inputMethod.fcitx5 = {
    enable = true;
    waylandFrontend = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
    };
  };
}
