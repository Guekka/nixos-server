{pkgs, ...}: {
  home.packages = [pkgs.ledger-live-desktop];

  myHome.impermanence.passthrough."/persist/nobackup" = {
    directories = [
      {
        directory = ".config/Ledger Live";
      }
    ];
  };
}
