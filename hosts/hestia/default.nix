{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/bluetooth.nix
    ../common/optional/brightness.nix
    ../common/optional/gamescope.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/obs-virtual-camera.nix
    ../common/optional/pipewire.nix
    ../common/optional/shutdown-schedule.nix
    ../common/optional/steam.nix
    ../common/optional/niri.nix
    ./hardware-configuration.nix
  ];

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_2000GB_24204D801353";

  networking = {
    hostName = "hestia";
    interfaces.enp42s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
    firewall.allowedTCPPorts = [5900];
  };

  services.tailscale = {
    extraUpFlags = ["--exit-node horus" "--exit-node-allow-lan-access"];
  };

  time.timeZone = "Europe/Amsterdam";

  boot.kernelParams = [
    # in case of failure
    "boot.shell_on_fail"
  ];

  sops.secrets.hestia-borgbackup-passphrase.sopsFile = ./secrets.yaml;

  services.udev.packages = [
    pkgs.qmk
  ];

  environment.systemPackages = [
    pkgs.qmk
  ];
}
