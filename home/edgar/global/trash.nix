{pkgs, ...}: {
  home.packages = [pkgs.gtrash];

  programs.fish.shellAbbrs = {
    tp = "gtrash put";
  };
}
