{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/impermanence-disko.nix
    ../common/optional/podman.nix
    ../common/optional/postgresql.nix
    ./acme.nix
    ./actualbudget.nix
    ./calibre-server.nix
    ./fail2ban.nix
    ./grocy.nix
    ./immich.nix
    ./hardware-configuration.nix
    ./hedgedoc.nix
    ./immich.nix
    ./microbin.nix
    ./netdata.nix
    ./nextcloud.nix
    ./nfs.nix
    ./nginx.nix
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
