{pkgs, ...}: {
  home = {
    packages = [pkgs.ledger-live-desktop];
    persistence."/persist/nobackup" = {
      directories = [
        {
          directory = ".config/Ledger Live";
        }
      ];
    };
  };
}
