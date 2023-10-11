{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      layout = "fr";
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gedit # text editor
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
    ]);

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.appindicator # tray icons
    gnomeExtensions.pop-shell
    gnomeExtensions.pop-launcher-super-key

    pop-launcher
  ];

  # tray icons
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  programs.dconf.enable = true;
}
