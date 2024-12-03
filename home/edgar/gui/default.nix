{pkgs, ...}: {
  imports = [
    ./dev.nix
    ./discord.nix
    ./file-manager.nix
    ./firefox.nix
    ./gtk.nix
    ./hyprland
    # currently broken    ./image-sieve.nix
    ./ledger.nix
    ./nextcloud-client.nix
    ./vscode.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    anytype
    beeper
    calibre
    keepassxc
    libsForQt5.ark
    obsidian
    plex-media-player
    plex-desktop
    ripdrag
    qbittorrent
    vlc
    wl-clipboard
  ];
}
