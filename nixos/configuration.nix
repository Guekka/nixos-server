# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # filesystems
  fileSystems."/".options = ["compress=zstd" "noatime" ];
  fileSystems."/home".options = ["compress=zstd" "noatime" ];
  fileSystems."/nix".options = ["compress=zstd" "noatime" ];
  fileSystems."/persist".options = ["compress=zstd" "noatime" ];
  fileSystems."/persist".neededForBoot = true;
  
  fileSystems."/var/log".options = ["compress=zstd" "noatime" ];
  fileSystems."/var/log".neededForBoot = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.mutableUsers = false;
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWVNch9BcjkMqS/Xwep+GN4HwqyRIjr3Cuw7mHpqsKr nixos" ]
;

    # passwordFile needs to be in a volume marked with `neededForBoot = true`
    passwordFile = "/persist/passwords/user";
  };
 
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.copySystemConfiguration = true;

  # Read the doc before updating
  system.stateVersion = "22.11";

}

