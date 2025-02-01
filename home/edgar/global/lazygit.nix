{
  lib,
  pkgs,
  ...
}: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        pager = "${lib.getExe pkgs.delta} --paging=never";
      };
    };
  };

  home = {
    persistence."/persist/backup/home/edgar".directories = [
      ".local/state/lazygit"
    ];
  };
}
