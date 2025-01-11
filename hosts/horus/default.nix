{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/impermanence/impermanence-disko-horus.nix
    ../common/optional/podman.nix
    ../common/optional/postgresql.nix
    ../common/optional/acme.nix
    ../common/optional/fail2ban.nix
    ../common/optional/netdata.nix
    ../common/optional/nfs.nix
    ../common/optional/nginx.nix
    ./actualbudget.nix
    ./calibre-server.nix
    ./grocy.nix
    ./hardware-configuration.nix
    ./hedgedoc.nix
    ./microbin.nix
    ./nextcloud.nix
    ./paperless.nix
    ./plausible.nix
    ./rss.nix
    ./tandoor.nix
    ./wallabag.nix
    ./web-server.nix
    ./wiki-js.nix
  ];

  networking = {
    hostName = "horus";
    interfaces.enp6s18.useDHCP = true;
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  sops.secrets.horus-borgbackup-passphrase.sopsFile = ./secrets.yaml;

  # TODO: investigate if this necessary
  nixpkgs.config.allowBroken = true;
}
