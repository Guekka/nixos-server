# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  imports = [
    ./android.nix
    ./backup.nix
    ./home-manager.nix
    ./mosh.nix
    ./networking.nix
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

  sops.secrets.shared-borgbackup-passphrase.sopsFile = ../secrets.yaml;

  # run external binaries
  programs.nix-ld.enable = true;

  # reisub
  boot.kernel.sysctl."kernel.sysrq" = 502;

  # use the new switch-to-configuration program instead of the perl script
  system.switch = {
    enable = false;
    enableNg = true;
  };

  # startup screen change
  boot.plymouth.enable = true;
  boot.kernelParams = [
    "plymouth.use-simpledrm"
    "quiet"
    "splash"

    # in case of failure
    "boot.shell_on_fail"
  ];

  # Read the doc before updating
  system.stateVersion = "24.11";

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Easy access to my nodes
  networking.extraHosts = ''
    horus.bizel.fr horus
    192.168.1.44 hestia
    192.168.1.72 deimos
  '';

  programs.dconf.enable = true; # required for some HM modules
}
