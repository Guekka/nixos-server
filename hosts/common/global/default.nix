# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  imports = [
    ./android.nix
    ./backup.nix
    ./home-manager.nix
    ./mosh.nix
    ./nfs.nix
    ./nix.nix
    ./nixpkgs.nix
    ./nh.nix
    ./ntfs.nix
    ./oomd.nix
    ./openssh.nix
    ./sops.nix
    ./systemd-boot.nix
    ./tailscale.nix
    ./users.nix
    ./xdg.nix
  ];

  # azerty
  console = {
    keyMap = "fr";
  };

  # gvfs needed for almost all file explorers
  services.gvfs.enable = true;

  # fix hanging at rebuild and wait-online service failing
  # See nixpkgs#180175
  systemd.services.NetworkManager-wait-online.enable = false;

  sops.secrets.shared-borgbackup-passphrase.sopsFile = ../secrets.yaml;

  # run external binaries
  programs.nix-ld.enable = true;

  # reisub
  boot.kernel.sysctl."kernel.sysrq" = 502;

  # Read the doc before updating
  system.stateVersion = "24.11";

  # Easy access to my nodes
  networking.extraHosts = ''
    horus.bizel.fr horus
    192.168.1.44 hestia
    192.168.1.72 deimos
  '';
}
