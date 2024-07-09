{...}: {
  imports = [
    ../common/global
    ../common/optional/bluetooth.nix
    ../common/optional/docker.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/nfs-client.nix
    ../common/optional/noisetorch.nix
    ../common/optional/openocd.nix
    ../common/optional/pipewire.nix
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

  time.timeZone = "Europe/London";

  # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  # Battery actions
  services.upower = {
    enable = true;
    percentageAction = 10;
    percentageCritical = 10;
    percentageLow = 15;
    criticalPowerAction = "Hibernate";
  };

  # brightness control
  programs.light.enable = true;

  # Read the doc before updating
  system.stateVersion = "22.11";

  sops.secrets.deimos-borgbackup-passphrase.sopsFile = ./secrets.yaml;
}
