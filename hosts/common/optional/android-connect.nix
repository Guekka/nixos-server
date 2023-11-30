{pkgs, ...}: {
  programs.kdeconnect = {
    enable = true;
  };

  environment.systemPackages = [pkgs.libsForQt5.kpeoplevcard];
}
