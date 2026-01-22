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
      pkgs.unstable.beeper
      chromium # for the rare occasion a website breaks on firefox
      jitsi-meet-electron
      keepassxc
      kobo-readstat
      overskride # bluetooth manager
      pkgs.unstable.plex-desktop
      ripdrag
      qbittorrent
      vlc
      winapps
      wl-clipboard
    ];

    persistence."/persist/nobackup" = {
      directories = [
        {
          directory = ".config/BeeperTexts";
        }
      ];
    };
  };
}
