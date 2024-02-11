{...}: {
  imports = [
    ../common/global
    ../common/optional/bluetooth.nix
    ../common/optional/docker.nix
    ../common/optional/fileshare-client.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/noisetorch.nix
    ../common/optional/pipewire.nix
    ../common/optional/steam.nix
    ../common/optional/wireless.nix
    ./hardware-configuration.nix
    ./openocd.nix
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

  # brightness control
  programs.light.enable = true;

  # Read the doc before updating
  system.stateVersion = "22.11";

  virtualisation.virtualbox = {
    host.enable = true;
  };
}
