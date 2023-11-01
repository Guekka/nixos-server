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
      ./direnv.nix
      ./eza.nix
      ./fish.nix
      ./font.nix
      ./fzf.nix
      ./git.nix
      ./helix.nix
      ./jq.nix
      ./nix-index.nix
      ./nvim.nix
      ./starship.nix
      ./topgrade.nix
      ./zoxide.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  colorScheme = inputs.nix-colors.colorSchemes.solarized-light;

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
