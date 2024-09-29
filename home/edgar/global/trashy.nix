{pkgs, ...}: {
  home.packages = [pkgs.stable.trashy];

  programs.fish.shellAbbrs = {
    tp = "trash put";
  };
}
