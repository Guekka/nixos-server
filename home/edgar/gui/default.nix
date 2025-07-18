{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./calibre.nix
    ./darkman.nix
    ./dev.nix
    ./discord.nix
    ./file-manager.nix
    ./firefox.nix
    ./gtk.nix
    ./ledger.nix
    ./nextcloud-client.nix
    ./niri
    ./vscode.nix
    ./zathura.nix
  ];

  wallpaper = lib.mkDefault ./background.webp;

  home = {
    packages = with pkgs; [
      beeper
      chromium # for the rare occasion a website breaks on firefox
      keepassxc
      kobo-readstat
      libsForQt5.ark
      overskride # bluetooth manager
      pkgs.unstable.plex-desktop
      ripdrag
      qbittorrent
      vlc
      winapps
      wl-clipboard
    ];

    persistence."/persist/nobackup/home/edgar" = {
      directories = [
        {
          directory = ".config/BeeperTexts";
          method = "symlink";
        }
      ];
    };
  };
}
