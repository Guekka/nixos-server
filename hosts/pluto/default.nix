{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/acme.nix
    ../common/optional/cloudflared.nix
    ../common/optional/dyndns.nix
    ../common/optional/fail2ban.nix
    ../common/optional/immich.nix
    ../common/optional/impermanence/impermanence.nix
    ../common/optional/karakeep.nix
    ../common/optional/kavita.nix
    ../common/optional/netdata.nix
    ../common/optional/nfs.nix
    ../common/optional/nginx.nix
    ../common/optional/podman.nix
    ../common/optional/postgresql.nix
    ../common/optional/stash.nix
    ../common/optional/yamtrack.nix

    ./hardware-configuration.nix
  ];

  disko.devices.disk.main.device = "scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";

  services.qemuGuest.enable = true;

  networking = {
    hostName = "pluto";
    hostId = "e847bfff";
    interfaces.enp6s18.useDHCP = true;
  };

  services.ddclient.domains = ["pluto.bizel.fr"];

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  sops.secrets.pluto-borgbackup-passphrase.sopsFile = ./secrets.yaml;
}
