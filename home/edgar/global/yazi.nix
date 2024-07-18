{pkgs, ...}: {
  home.packages = with pkgs; [exiftool mediainfo mpv]; # yazi uses these for preview
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
