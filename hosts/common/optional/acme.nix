{config, ...}: {
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "trucmuche909@gmail.com";
    acceptTerms = true;

    certs."bizel.fr" = {
      domain = "*.bizel.fr";
      dnsProvider = "ovh";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets.ovhDns.path;
    };
  };

  environment.persistence = {
    "/persist".directories = ["/var/lib/acme"];
  };

  sops.secrets.ovhDns = {
    sopsFile = ../secrets.yaml;
  };

  users.users.nginx.extraGroups = ["acme"];
}
