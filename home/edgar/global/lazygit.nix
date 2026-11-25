{
  lib,
  pkgs,
  ...
}: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        {pager = "${lib.getExe pkgs.delta} --paging=never";}
      ];
    };
  };

  myHome = {
    impermanence.passthrough."/persist/backup".directories = [
      ".local/state/lazygit"
    ];
  };
}
