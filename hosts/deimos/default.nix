{...}: {
  imports = [
    ../common/global
    ../common/optional/hyprland.nix
    ../common/optional/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/nfs-client.nix
    ../common/optional/noisetorch.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/steam.nix
    ../common/optional/wireless.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "deimos";
    interfaces.eno1.useDHCP = true;
  };

  services.tailscaleAutoconnect = {
    advertiseExitNode = false;
    exitNode = "horus";
    exitNodeAllowLanAccess = true;
  };

  time.timeZone = "Europe/Amsterdam";

  # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  # Read the doc before updating
  system.stateVersion = "22.11";

  virtualisation.virtualbox = {
    host.enable = true;
  };
}
