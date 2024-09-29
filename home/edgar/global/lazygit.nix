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
}
