{pkgs, ...}: {
  home.packages = [pkgs.trashy];

  programs.fish.shellAbbrs = {
    tp = "trash put";
  };
}
