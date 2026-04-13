{
  config,
  lib,
  ...
}: let
  cfg = config.services.pocket-id-sso;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.services.pocket-id-sso = {
    enable = mkEnableOption "Pocket ID SSO through oauth2-proxy";

    issuerUrl = mkOption {
      type = types.str;
      description = "OIDC issuer URL exposed by Pocket ID.";
      example = "https://pocket-id.bizel.fr";
    };

    clientID = mkOption {
      type = types.str;
      description = "OIDC client ID used by oauth2-proxy.";
      example = "horus-services";
    };

    keyFile = mkOption {
      type = types.path;
      description = "Path to an environment file containing oauth2-proxy secrets.";
      example = "/run/secrets/pocket-id-oauth2-env";
    };

    redirectURL = mkOption {
      type = types.str;
      description = "OAuth2 redirect URL handled by oauth2-proxy.";
      example = "https://actual.bizel.fr/oauth2/callback";
    };

    cookieDomain = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Optional cookie domain for sharing sessions between subdomains.";
      example = ".bizel.fr";
    };

    emailDomains = mkOption {
      type = types.listOf types.str;
      default = ["*"];
      description = "Allowed email domains for oauth2-proxy.";
    };

    protectedVirtualHosts = mkOption {
      type = with types; attrsOf attrs;
      default = {};
      description = "Nginx virtual hosts protected by oauth2-proxy auth_request.";
      example = {
        "actual.bizel.fr" = {};
      };
    };

    proxyDomain = mkOption {
      type = types.str;
      description = "Domain that serves the oauth2-proxy /oauth2 endpoints for nginx redirects.";
      example = "actual.bizel.fr";
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [
    {
      services.oauth2-proxy = {
        enable = true;
        provider = "oidc";
        oidcIssuerUrl = cfg.issuerUrl;
        clientID = cfg.clientID;
        keyFile = cfg.keyFile;
        redirectURL = cfg.redirectURL;
        reverseProxy = true;
        setXauthrequest = true;
        email.domains = cfg.emailDomains;
        upstream = ["static://202"];
        nginx = {
          domain = cfg.proxyDomain;
          virtualHosts = cfg.protectedVirtualHosts;
        };
      };
    }
    (mkIf (cfg.cookieDomain != null) {
      services.oauth2-proxy.cookie.domain = cfg.cookieDomain;
    })
  ]);
}
