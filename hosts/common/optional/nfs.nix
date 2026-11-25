{
  config,
  lib,
  ...
}: let
  ports = [2049 4000 4001 4002];
  trustedNetworks = ["192.168.1.0/24" "100.64.0.0/10"];
  protocols = ["tcp" "udp"];
  portList = lib.concatStringsSep "," (map toString ports);
  exportOptions = "rw,async,wdelay,root_squash,no_subtree_check";
  exports = "/shared ${lib.concatMapStringsSep " " (network: "${network}(${exportOptions})") trustedNetworks}";
  iptablesRules =
    lib.concatMapStrings (
      network:
        lib.concatMapStrings (protocol: ''
          iptables -w -A nixos-fw -p ${protocol} -s ${network} -m multiport --dports ${portList} -j nixos-fw-accept
        '')
        protocols
    )
    trustedNetworks;
  nftablesRules =
    lib.concatMapStrings (protocol: ''
      ip saddr { ${lib.concatStringsSep ", " trustedNetworks} } ${protocol} dport { ${lib.concatStringsSep ", " (map toString ports)} } accept
    '')
    protocols;
in {
  services.nfs = {
    server = {
      enable = true;
      inherit exports;
    };
  };

  networking.firewall = {
    extraCommands = lib.mkIf (config.networking.firewall.backend == "iptables") iptablesRules;
    extraInputRules = lib.mkIf (config.networking.firewall.backend == "nftables") nftablesRules;
  };
}
