{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  myHome.impermanence.passthrough."/persist/nobackup".directories = [
    ".local/share/direnv"
  ];
}
