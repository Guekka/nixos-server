{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batman batgrep batwatch batpipe prettybat];
  };

  home.persistence."/persist/nobackup/home/edgar".directories = [
    ".cache/bat"
  ];
}
