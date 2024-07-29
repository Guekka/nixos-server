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

  home.packages = with pkgs.stable; [
    anytype
    pkgs.beeper # evolves fast
    calibre
    keepassxc
    libsForQt5.ark
    obsidian
    plex-media-player
    pkgs.plex-desktop # TODO: move to stable when 24.11
    qbittorrent
    vlc
    wl-clipboard
  ];
}
