{config, ...}: {
  services.tailscale = {
    enable = true;
    extraUpFlags = ["--login-server" "https://headscale.ozeliurs.com"];
    useRoutingFeatures = "both";

    authKeyFile = config.sops.secrets.tailscale_key.path;
  };

  sops.secrets.tailscale_key.sopsFile = ../secrets.yaml;

  environment.persistence = {
    "/persist/backup".directories = ["/var/lib/tailscale"];
  };
}
