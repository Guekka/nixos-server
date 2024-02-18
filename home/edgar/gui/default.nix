{pkgs, ...}: {
  imports = [
    ./activitywatch.nix
    ./cursor.nix
    ./dev.nix
    ./discord.nix
    ./file-manager.nix
    ./firefox.nix
    ./gtk.nix
    ./hyprland
    ./image-sieve.nix
    ./ledger.nix
    ./qt.nix
    ./vscode.nix
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
