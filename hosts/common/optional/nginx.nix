{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    clientMaxBodySize = "300m";
  };

  networking.firewall.allowedTCPPorts = [80 443];

  # catch-all
  services.nginx.virtualHosts."_" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    default = true;
    locations."~ .*".return = "403";
  };
}
