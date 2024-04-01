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

  home.packages = with pkgs.stable; [
    anytype
    calibre
    keepassxc
    libsForQt5.ark
    pkgs.obsidian # TODO: move to stable when 24.05 releases
    plex-media-player
    qbittorrent
    vlc
    wl-clipboard
  ];
}
