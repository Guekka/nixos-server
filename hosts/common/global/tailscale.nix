{config, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";

    authKeyFile = config.sops.secrets.tailscale_key.path;
  };

  sops.secrets.tailscale_key.sopsFile = ../secrets.yaml;

  environment.persistence = {
    "/persist/backup".directories = ["/var/lib/tailscale"];
  };
}
