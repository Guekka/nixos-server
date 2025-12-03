{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      ./impermanence.nix

      ./atuin.nix
      ./bash.nix
      ./beeper-timestamp-converter.nix
      ./bat.nix
      ./calendar.nix
      ./direnv.nix
      ./eza.nix
      ./fish.nix
      ./fzf.nix
      ./git.nix
      ./helix
      ./jq.nix
      ./jujutsu.nix
      ./kitty.nix
      ./lazygit.nix
      ./mime.nix
      ./nix-index.nix
      ./ripgrep.nix
      ./rclone.nix
      ./starship.nix
      ./stylix.nix
      ./top.nix
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

  home.packages = let
    # I'm not sure this is the proper way to do this, but it works for me
    ifSupported = package: lib.optionals (builtins.elem pkgs.stdenv.hostPlatform package.meta.platforms) [package];
  in
    with pkgs;
      [
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
        _7zz-rar
        rnr
        sd
        sshfs
        unsilence
        xcp
      ]
      ++ (ifSupported pkgs.intentrace);
}
