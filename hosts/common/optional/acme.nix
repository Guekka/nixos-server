{config, ...}: {
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "trucmuche909@gmail.com";
    acceptTerms = true;

    certs."bizel.fr" = {
      domain = "*.bizel.fr";
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets.cloudflare-lego-token.path;
    };
  };

  environment.persistence = {
    "/persist/backup".directories = ["/var/lib/acme"];
  };

  sops.secrets.cloudflare-lego-token = {
    sopsFile = ../secrets.yaml;
  };

  users.users.nginx.extraGroups = ["acme"];
}
