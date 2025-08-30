{config, ...}: let
  port = 18447;
in {
  # Jokes aside, Stash is great for viewing content when previews are useful,
  # such as gameplay
  services.stash = {
    enable = true;

    username = "admin";
    passwordFile = config.sops.secrets.stash-password.path;
    jwtSecretKeyFile = config.sops.secrets.stash-jwt.path;
    sessionStoreKeyFile = config.sops.secrets.stash-session-store.path;

    mutableScrapers = true;
    mutablePlugins = true;

    settings = {
      inherit port;
      stash = [
        {
          path = "/var/lib/stash/data";
        }
      ];
    };
  };

  sops.secrets.stash-password.sopsFile = ../secrets.yaml;
  sops.secrets.stash-jwt.sopsFile = ../secrets.yaml;
  sops.secrets.stash-session-store.sopsFile = ../secrets.yaml;

  services.nginx.virtualHosts."sta.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/stash";
        mode = "0750";
        user = "stash";
        group = "stash";
      }
    ];
  };
}
