{pkgs, ...}: {
  imports = [
    ./calibre.nix
    ./dev.nix
    ./discord.nix
    ./file-manager.nix
    ./firefox.nix
    ./gtk.nix
    ./hyprland
    ./ledger.nix
    ./nextcloud-client.nix
    ./vscode.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    beeper
    keepassxc
    libsForQt5.ark
    obsidian
    overskride # bluetooth manager
    plex-desktop
    ripdrag
    qbittorrent
    vlc
    wl-clipboard
  ];
}
