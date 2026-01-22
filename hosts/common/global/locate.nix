{pkgs, ...}: {
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    pruneNames = [
      ".bzr"
      ".cache"
      ".direnv"
      ".git"
      ".hg"
      ".jj"
      ".svn"
    ];
  };
}
