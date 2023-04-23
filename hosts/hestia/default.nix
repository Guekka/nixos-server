{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/global
    ../common/optional/impermanence.nix
    ../common/optional/pipewire.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "hestia";
    interfaces.enp42s0.useDHCP = true;
  };

  time.timeZone = "Europe/Amsterdam";

  # Read the doc before updating
  system.stateVersion = "22.11";
}
