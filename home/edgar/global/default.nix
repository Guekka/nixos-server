{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./exa.nix
    ./firefox.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./jq.nix
    ./nix-index.nix
    ./nvim.nix
    ./starship.nix
    ./topgrade.nix
    ./wezterm.nix
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
    anytype
    cmake
    comma
    discord
    duf
    du-dust
    fd
    gcc
    gnumake
    hexyl
    keepassxc
    kondo
    libsForQt5.ark
    lutris
    maven
    obsidian
    python3
    p7zip
    qbittorrent
    qrcp
    vlc
    vscode
    wezterm
    wireguard-tools
    wget
  ];
}
