{pkgs, ...}: {
  imports = [
    ./activitywatch.nix
    ./firefox.nix
    ./gnome.nix
    ./image-sieve.nix
    ./jetbrains.nix
    ./kitty.nix
    ./ledger.nix
    ./wezterm.nix
  ];

  home.packages = with pkgs; [
    anytype
    discord
    keepassxc
    nemo-with-extensions
    obsidian
    qbittorrent
    vlc
    vscode
  ];
}
