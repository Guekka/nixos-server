# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  imports = [
    ./acme.nix
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

  # fix hanging at rebuild and wait-online service failing
  # See nixpkgs#180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
