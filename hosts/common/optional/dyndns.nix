{config, ...}: {
  services.ddclient = {
    enable = true;
    secretsFile = config.sops.secrets.ddclient.path;

    protocol = "cloudflare";
    ssl = true;
    usev4 = "webv4";
  };

  sops.secrets.ddclient.sopsFile = ../secrets.yaml;
}
