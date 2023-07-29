{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Edgar B";
    userEmail = "39066502+Guekka@users.noreply.github.com";

    extraConfig = {
      feature.manyFiles = true;
      init.defaultBranch = "main";
    };
    ignores = [".direnv" "result"];

    difftastic = {
      enable = true;
    };
  };

  home.packages = [
    pkgs.git-absorb
  ];
}
