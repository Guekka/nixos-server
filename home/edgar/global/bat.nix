{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batman batgrep batwatch batpipe prettybat];
  };

  myHome.impermanence.passthrough."/persist/nobackup".directories = [
    ".cache/bat"
  ];
}
