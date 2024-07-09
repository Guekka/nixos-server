{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.theme = "base16";
    extraPackages = with pkgs.bat-extras; [batman batgrep batwatch batpipe prettybat];
  };
}
