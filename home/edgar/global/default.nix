{config, pkgs, ...}: {
  home = {
    username = "edgar";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "22.11";
  };

  # direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    alejandra
    android-studio
    anytype
    bat
    bottom
    cmake
    comma
    discord
    duf
    du-dust
    difftastic
    exa
    fd
    firefox
    fzf
    gcc
    git
    gnumake
    helix
    hexyl
    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.gateway
    jq
    keepassxc
    kondo
    libsForQt5.ark
    maven
    nix-direnv
    obsidian
    python3
    p7zip
    qbittorrent
    qrcp
    starship
    tailscale
    topgrade
    vlc
    vscode
    vim
    wezterm
    wireguard-tools
    wget
    zoxide
  ];
  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Configure wezterm
  programs.wezterm.extraConfig = ''return { color_scheme = "Solarized Light (base16)", }'';
}
