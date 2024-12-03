{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/impermanence-disko-zfs.nix
    ../common/optional/podman.nix
    ../common/optional/postgresql.nix
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
