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
      ./mime.nix
      ./nix-index.nix
      ./rclone.nix
      ./starship.nix
      ./stylix.nix
      ./trashy.nix
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

  home.packages = with pkgs.stable; [
    alejandra
    comma
    csvlens
    dua
    duf
    du-dust
    fd
    ffmpeg
    hexyl
    nix-init
    kondo
    p7zip
    ripgrep
    rnr
    sshfs
    pkgs.tcount # custom package
    unsilence
  ];
}
