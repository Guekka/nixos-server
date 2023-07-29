{pkgs, ...}: {
  imports = [
    ./activitywatch.nix
    ./dev.nix
    ./firefox.nix
    ./gnome.nix
    ./image-sieve.nix
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
    wl-clipboard
  ];
}
