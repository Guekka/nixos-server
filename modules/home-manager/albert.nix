{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.albert;
in {
  options.services.albert = {
    enable = lib.mkEnableOption "albert";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.albert;
      description = "Albert package to use.";
      defaultText = lib.literalExpression "pkgs.albert";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
