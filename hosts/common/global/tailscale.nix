{
  services.tailscale = {
    enable = true;
    extraUpFlags = ["--login-server" "https://headscale.ozeliurs.com"];
    useRoutingFeatures = "both";
  };

  sops.secrets.tailscale_key.sopsFile = ../secrets.yaml;

  environment.persistence = {
    "/persist".directories = ["/var/lib/tailscale"];
  };
}
