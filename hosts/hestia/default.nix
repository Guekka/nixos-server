{pkgs, ...}: {
  imports = [
    ../common/global
    ../common/optional/android-connect.nix
    ../common/optional/bluetooth.nix
    ../common/optional/brightness.nix
    ../common/optional/docker.nix
    ../common/optional/gamescope.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/nfs-client.nix
    ../common/optional/noisetorch.nix
    ../common/optional/obs-virtual-camera.nix
    ../common/optional/openocd.nix
    ../common/optional/pipewire.nix
    ../common/optional/shutdown-schedule.nix
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
