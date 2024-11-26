{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/impermanence-disko.nix
    ../common/optional/podman.nix
    ../common/optional/postgresql.nix
  ];

  networking = {
    hostName = "pluto";
    interfaces.enp6s18.useDHCP = true;
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  sops.secrets.pluto-borgbackup-passphrase.sopsFile = ./secrets.yaml;
}
