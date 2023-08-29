{pkgs, ...}: {
  home.pointerCursor = {
    name = "Capitaine Cursors (Nord)";
    package = pkgs.capitaine-cursors-themed;
    size = 32;

    gtk.enable = true;
    x11.enable = true;
  };
}
