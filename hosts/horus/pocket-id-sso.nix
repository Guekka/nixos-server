{
  config,
  outputs,
  ...
}: let
  authHost = "auth.bizel.fr";
in {
  imports = [outputs.nixosModules.pocket-id-sso];

  sops.secrets.pocket-id-oauth2-env.sopsFile = ./secrets.yaml;

  services.pocket-id-sso = {
    enable = true;
    issuerUrl = "https://pocket-id.bizel.fr";
    clientID = "horus-services";
    keyFile = config.sops.secrets.pocket-id-oauth2-env.path;
    redirectURL = "https://${authHost}/oauth2/callback";
    proxyDomain = authHost;
    cookieDomain = ".bizel.fr";
  };

  services.nginx.virtualHosts."${authHost}" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."/".return = "404";
  };
}
