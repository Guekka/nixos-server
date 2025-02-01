{...}: {
  imports = [
    ../common/global
    ../common/optional/bluetooth.nix
    ../common/optional/docker.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence/impermanence-old.nix
    ../common/optional/ledger.nix
    ../common/optional/nfs-client.nix
    ../common/optional/noisetorch.nix
    ../common/optional/openocd.nix
    ../common/optional/pipewire.nix
    ../common/optional/shutdown-schedule.nix
    ../common/optional/steam.nix
    ../common/optional/wireless.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "deimos";
    interfaces.eno1.useDHCP = true;
  };

  services.tailscale.extraUpFlags = ["--exit-node" "horus" "--exit-node-allow-lan-access"];

  time.timeZone = "Europe/Amsterdam";

  # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
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

  sops.secrets.deimos-borgbackup-passphrase.sopsFile = ./secrets.yaml;
}
