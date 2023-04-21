# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/global
    ../common/optional/impermanence.nix
    ./hardware-configuration.nix
    ./nginx.nix
    ./podman.nix
    ./users.nix
    ./web-server.nix
  ];

  networking = {
    hostName = "horus";
    interfaces.enp6s18.useDHCP = true;
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # Read the doc before updating
  system.stateVersion = "22.11";
}
