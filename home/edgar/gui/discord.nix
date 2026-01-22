{pkgs, ...}: let
  dataDir = ".config/vesktop";
in {
  home = {
    packages = [
      pkgs.vesktop
    ];

    # for some reason, this doesn't appear to work, but it should:
    # <https://github.com/Vencord/Vesktop/blob/786c3cc1969770e15260b47e71558b51f3f88358/src/main/constants.ts>
    # sessionVariables."VENCORD_USER_DATA_DIR" = "/home/edgar/${dataDir}";

    persistence."/persist/nobackup".directories = [
      dataDir
    ];
  };
}
