{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/global
    ../common/optional/gnome.nix
    ../common/optional/impermanence.nix
    ../common/optional/noisetorch.nix
    ../common/optional/pipewire.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "deimos";
    interfaces.eno1.useDHCP = true;
  };

  time.timeZone = "Europe/Amsterdam";

  # Read the doc before updating
  system.stateVersion = "22.11";
}