{
  config,
  lib,
  pkgs,
  ...
}: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "5986ed26-feb9-4453-a86c-a2f1cd5cf547" = {
        credentialsFile = config.sops.secrets.cloudflare.path;
        default = "http_status:404";
        ingress = {
          "*.bizel.fr" = {
            service = "http://localhost:80";
            originRequest.originServerName = "*.bizel.fr";
          };
        };
      };
    };
  };

  systemd.services.cloudflared-tunnel-5986ed26-feb9-4453-a86c-a2f1cd5cf547.serviceConfig = {
    User = "cloudflared";
    Group = "cloudflared";
  };

  users = {
    groups.cloudflared = {};
    users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
    };
  };

  boot.kernel.sysctl."net.core.rmem_max" = 7500000;
  boot.kernel.sysctl."net.core.wmem_max" = 7500000;

  sops.secrets.cloudflare = {
    owner = "cloudflared";
    sopsFile = ../secrets.yaml;
  };

  # Using realIP when behind CloudFlare
  services.nginx.commonHttpConfig = let
    realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
    fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
    cfipv4 = fileToList (pkgs.fetchurl {
      url = "https://www.cloudflare.com/ips-v4";
      sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
    });
    cfipv6 = fileToList (pkgs.fetchurl {
      url = "https://www.cloudflare.com/ips-v6";
      sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
    });
  in ''
    ${realIpsFromList cfipv4}
    ${realIpsFromList cfipv6}
    real_ip_header CF-Connecting-IP;
  '';
}
