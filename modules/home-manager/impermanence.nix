{
  config,
  lib,
  options,
  ...
}: let
  cfg = config.myHome.impermanence;
  hasPersistenceOption = lib.hasAttrByPath ["home" "persistence"] options;
in {
  options.myHome.impermanence = {
    enable = lib.mkEnableOption "impermanence";

    passthrough = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf (lib.types.listOf lib.types.anything));
      default = {};
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable (lib.optionalAttrs hasPersistenceOption {
      home.persistence = cfg.passthrough;
    }))
    (lib.mkIf (cfg.enable && !hasPersistenceOption) {
      assertions = [
        {
          assertion = false;
          message = "myHome.impermanence.enable requires the home.persistence option";
        }
      ];
    })
  ];
}
