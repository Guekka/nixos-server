{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.persistence."/persist/nobackup".directories = [
    ".local/share/direnv"
  ];
}
