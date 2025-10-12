{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common/global
    ../common/optional/bluetooth.nix
    ../common/optional/brightness.nix
    ../common/optional/gamescope.nix
    ../common/optional/impermanence/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/niri.nix
    ../common/optional/obs-virtual-camera.nix
    ../common/optional/pipewire.nix
    ../common/optional/shutdown-schedule.nix
    ../common/optional/steam.nix
    ./hardware-configuration.nix

    inputs.chaotic.nixosModules.mesa-git
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
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

  sops.secrets.hestia-borgbackup-passphrase.sopsFile = ./secrets.yaml;

  services.udev.packages = [
    pkgs.qmk
  ];

  environment.systemPackages = [
    pkgs.qmk
  ];

  # see <https://github.com/chaotic-cx/nyx/issues/1158#issuecomment-3216945109>
  system.modulesTree = [(lib.getOutput "modules" pkgs.linuxPackages_cachyos-lto.kernel)];
  boot = {
    kernelParams = [
      # in case of failure
      "boot.shell_on_fail"
      # see <https://lwn.net/Articles/911219/>
      "split_lock_detect=off"
    ];

    # Using very new hardware
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-lto;
  };

  chaotic = {
    mesa-git.enable = true;
    nyx.cache.enable = true;
  };
}
