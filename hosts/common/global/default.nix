# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ./backup.nix
    ./home-manager.nix
    ./mosh.nix
    ./nfs.nix
    ./nix.nix
    ./nixpkgs.nix
    ./ntfs.nix
    ./oomd.nix
    ./openssh.nix
    ./sops.nix
    ./systemd-boot.nix
    ./tailscale.nix
    ./users.nix
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

  # Display changes after rebuild, see https://discourse.nixos.org/t/how-to-make-nixos-rebuild-output-more-informative/25549/8
  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      echo "NixOS system closure diff:"
      ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
    fi
  '';

  sops.secrets.shared-borgbackup-passphrase.sopsFile = ../secrets.yaml;

  # Latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
