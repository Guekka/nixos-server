# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/impermanence-disko.nix
    ../common/optional/podman.nix
    ../common/optional/samba-client.nix
    ./acme.nix
    ./actualbudget.nix
    ./calibre-server.nix
    ./fail2ban.nix
    ./grocy.nix
    ./immich.nix
    ./hardware-configuration.nix
    ./immich.nix
    ./jitsi.nix
    ./mattermost.nix
    ./microbin.nix
    ./navidrome.nix
    ./netdata.nix
    ./nextcloud.nix
    ./nfs.nix
    ./nginx.nix
    ./paperless.nix
    ./plausible.nix
    # ./plex.nix
    ./postgresql.nix
    # ./qbittorrent.nix # needs to change the docker image to aarm64
    ./rss.nix
    ./tandoor.nix
    ./uptime-kuma.nix
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

  # Read the doc before updating
  system.stateVersion = "22.11";
  nixpkgs.config.allowBroken = true;
}
