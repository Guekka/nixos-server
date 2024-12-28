{config, ...}: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "5986ed26-feb9-4453-a86c-a2f1cd5cf547" = {
        credentialsFile = config.sops.secrets.cloudflare.path;
        default = "http_status:404";
        ingress = {
          "*.bizel.fr".service = "http://localhost:80";
        };
        originRequest.noTLSVerify = true;
      };
    };
  };

  sops.secrets.cloudflare = {
    owner = "cloudflared";
    sopsFile = ../secrets.yaml;
  };
}
