{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/global
    ../common/optional/gnome.nix
    ../common/optional/impermanence.nix
    ../common/optional/pipewire.nix
    ./amdgpu-fix-sleep.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "hestia";
    interfaces.enp42s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
  };

  time.timeZone = "Europe/Amsterdam";

  # Read the doc before updating
  system.stateVersion = "22.11";
}
