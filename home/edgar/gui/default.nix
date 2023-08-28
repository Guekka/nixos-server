{pkgs, ...}: {
  imports = [
    ./activitywatch.nix
    ./dev.nix
    ./discord.nix
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
    keepassxc
    obsidian
    qbittorrent
    vlc
    wl-clipboard
  ];
}
