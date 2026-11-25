{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.nonNixos;
in {
  options.myHome.nonNixos = with lib; {
    enable = mkEnableOption "nonNixos";
  };
  config = lib.mkIf cfg.enable {
    home = {
      sessionPath = ["$HOME/.local/bin"];

      packages = [
        pkgs.hostname
        config.nix.package # This must be here, enable option below does not ensure that nix is available in path
      ];
    };

    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      config.allowUnfree = true;
    };

    nix = {
      enable = true;
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    };

    programs.home-manager.enable = true;

    targets.genericLinux = {
      enable = true;
      gpu.enable = true;
    };

    # When XDG_CONFIG_DIRS is modified, it should get the original value appended at the end
    # But for some reason on my Ubuntu, the original value is empty at the point of evaluation (GDM login)
    # This results in a session crash, as "/etc/xdg" is required
    # As a workaround, always set this value just in case
    xdg.systemDirs.config = ["/etc/xdg"];
  };
}
