{
  pkgs,
  outputs,
  ...
}: {
  imports = [outputs.nixosModules.wallabag];

  services.wallabag = {
    enable = true;
    domain = "wallabag.bizel.fr";
    secretPath = pkgs.writeText "test" "test";
  };

  services.nginx.virtualHosts."wallabag.bizel.fr" = {
    useACMEHost = "bizel.fr";
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/wallabag";
        user = "wallabag";
        group = "wallabag";
        mode = "0700";
      }
    ];
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "wallabag";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "wallabag"
    ];
  };
}
