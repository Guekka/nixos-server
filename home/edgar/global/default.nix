{
  config,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      ./atuin.nix
      ./bash.nix
      ./bat.nix
      ./bottom.nix
      ./calendar.nix
      ./direnv.nix
      ./eza.nix
      ./fish.nix
      ./fzf.nix
      ./git.nix
      ./helix
      ./jq.nix
      ./kitty.nix
      ./lazygit.nix
      ./mime.nix
      ./nix-index.nix
      ./rclone.nix
      ./starship.nix
      ./stylix.nix
      ./trash.nix
      ./xdg.nix
      ./yazi.nix
      ./zoxide.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

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
    choose
    comma
    csvlens
    cyme
    dua
    doggo
    duf
    du-dust
    dysk
    fd
    ffmpeg
    ghostscript # for imagemagick
    hexyl
    imagemagickBig
    nix-init
    ouch
    p7zip-rar
    ripgrep
    rnr
    sd
    sshfs
    unsilence
    xcp
  ];
}
