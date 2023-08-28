{pkgs, ...}: {
  imports = [
    ./activitywatch.nix
    ./dev.nix
    ./firefox.nix
    ./gtk.nix
    ./hyprland
    ./image-sieve.nix
    ./kitty.nix
    ./ledger.nix
    ./nemo.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    anytype
    discord
    keepassxc
    obsidian
    qbittorrent
    vlc
    wl-clipboard
  ];
}
