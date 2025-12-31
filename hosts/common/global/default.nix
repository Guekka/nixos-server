{pkgs, ...}: {
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

  # See <https://github.com/kachick/dotfiles/issues/959>
  # In my case, the new kernel wasn't enough. aw-server is refusing to freeze
  # And I can't investigate right now
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

  # reisub
  boot.kernel.sysctl."kernel.sysrq" = 502;

  # startup screen change
  boot.plymouth.enable = true;
  boot.kernelParams = [
    "plymouth.use-simpledrm"
    "quiet"
    "splash"
  ];

  # Read the doc before updating
  system.stateVersion = "24.11";

  # For home manager
  programs.fuse.userAllowOther = true;

  # Easy access to my nodes
  networking.extraHosts = ''
    horus.bizel.fr horus
    192.168.1.44 hestia
    192.168.1.72 deimos
    192.168.1.91 pluto
  '';

  programs.dconf.enable = true; # required for some HM modules
}
