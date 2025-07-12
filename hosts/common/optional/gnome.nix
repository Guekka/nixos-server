{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "fr";
      desktopManager.gnome = {
        enable = true;
      };
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    cheese # webcam tool
    gnome-music
    pkgs.gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    nautilus # file manager
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ];
}
