{
  config,
  inputs,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      inputs.nix-colors.homeManagerModules.default

      ./atuin.nix
      ./bat.nix
      ./bottom.nix
      ./calendar.nix
      ./direnv.nix
      ./eza.nix
      ./fish.nix
      ./font.nix
      ./fzf.nix
      ./git.nix
      ./helix.nix
      ./jq.nix
      ./kitty.nix
      ./mime.nix
      ./nix-index.nix
      ./nvim
      ./starship.nix
      ./xdg.nix
      ./yazi.nix
      ./zoxide.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  colorScheme = inputs.nix-colors.colorSchemes.selenized-light;

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
    kondo
    p7zip
    rclone
    ripgrep
    rnr
    tcount
    unsilence
  ];
}
