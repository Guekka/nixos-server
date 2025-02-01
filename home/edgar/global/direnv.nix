{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.persistence."/persist/nobackup/home/edgar".directories = [
    ".local/share/direnv"
  ];
}
