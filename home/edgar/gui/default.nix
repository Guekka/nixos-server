{pkgs, ...}: {
  imports = [
    ./cursor.nix
    ./dev.nix
    ./discord.nix
    ./file-manager.nix
    ./firefox.nix
    ./gtk.nix
    ./hyprland
    # currently broken    ./image-sieve.nix
    ./ledger.nix
    ./nextcloud-client.nix
    ./qt.nix
    ./vscode.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    anytype
    calibre
    clight-gui
    keepassxc
    libsForQt5.ark
    obsidian
    plex-media-player
    qbittorrent
    vlc
    wl-clipboard
  ];
}
