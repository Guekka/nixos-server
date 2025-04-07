{pkgs, ...}: {
  home = {
    packages = [pkgs.ledger-live-desktop];
    persistence."/persist/nobackup/home/edgar" = {
      directories = [
        {
          directory = ".config/Ledger Live";
          method = "symlink";
        }
      ];
    };
  };
}
