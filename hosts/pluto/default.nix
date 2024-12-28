{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/acme.nix
    ../common/optional/cloudflared.nix
    ../common/optional/fail2ban.nix
    ../common/optional/immich.nix
    ../common/optional/impermanence-disko-2.nix
    ../common/optional/netdata.nix
    ../common/optional/nfs.nix
    ../common/optional/nginx.nix
    ../common/optional/podman.nix
    ../common/optional/postgresql.nix

    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "pluto";
    hostId = "e847bfff";
    interfaces.enp6s18.useDHCP = true;
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  sops.secrets.pluto-borgbackup-passphrase.sopsFile = ./secrets.yaml;
}
