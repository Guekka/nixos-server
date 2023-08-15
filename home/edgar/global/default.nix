{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./exa.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./jq.nix
    ./nix-index.nix
    ./nvim.nix
    ./starship.nix
    ./topgrade.nix
    ./zoxide.nix
  ];

  home = {
    username = "edgar";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    alejandra
    comma
    csvlens
    duf
    du-dust
    fd
    ffmpeg
    hexyl
    nix-init
    p7zip
    ripgrep
    rnr
    tcount
  ];
}
