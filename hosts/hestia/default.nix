{...}: {
  imports = [
    ../common/global
    ../common/optional/android-connect.nix
    ../common/optional/bluetooth.nix
    ../common/optional/brightness.nix
    ../common/optional/fileshare-client.nix
    ../common/optional/gamescope.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/noisetorch.nix
    ../common/optional/obs-virtual-camera.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/steam.nix
    ../common/optional/thunar.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "hestia";
    interfaces.enp42s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
  };

  services.tailscaleAutoconnect = {
    advertiseExitNode = false;
    exitNode = "horus";
    exitNodeAllowLanAccess = true;
  };

  time.timeZone = "Europe/Amsterdam";

  # Read the doc before updating
  system.stateVersion = "22.11";
}
