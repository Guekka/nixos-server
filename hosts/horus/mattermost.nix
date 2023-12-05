{pkgs, ...}: {
  services.mattermost = {
    enable = true;
    siteUrl = "https://mattermost.bizel.fr";
    preferNixConfig = true;
    plugins = [
      (pkgs.fetchurl {
        url = "https://github.com/mattermost/mattermost-plugin-calls/releases/download/v0.16.1/com.mattermost.calls-0.16.1.tar.gz";
        hash = "sha256-BCNFmKIxNJnuz0r4SnJn/9apvEjggmTXhJ0EEtFT590=";
      })
    ];
  };

  services.nginx.virtualHosts."mattermost.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:8065";
      proxyWebsockets = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/mattermost";
        mode = "0750";
        user = "mattermost";
        group = "mattermost";
      }
    ];
  };
}
