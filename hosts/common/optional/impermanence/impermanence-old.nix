{
  config,
  lib,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  disk = "/dev/disk/by-label/${hostname}";
  rollback-script = pkgs.writeShellScript "btrfs-rollback-script" (builtins.readFile ./btrfs-rollback-script.sh);
in {
  imports = [./impermanence-common.nix];

  # We're making the assumption the disk has a label
  fileSystems = {
    "/" = {
      device = disk;
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };

    "/home" = lib.mkDefault {
      device = disk;
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/nix" = {
      device = disk;
      fsType = "btrfs";
      options = ["subvol=nix" "noatime" "compress=zstd"];
    };

    "/persist" = {
      device = disk;
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd"];
      neededForBoot = true;
    };

    "/var/log" = {
      device = disk;
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd"];
      neededForBoot = true;
    };
  };

  # source: https://mt-caret.github.io/blog/2020-06-29-optin-state.html
  # and: https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
  boot.initrd.systemd.enable = lib.mkDefault true;
  boot.initrd.systemd.services.rollback = {
    wantedBy = [
      "initrd.target"
    ];
    requires = [
      # wait for device to be found
      "dev-disk-by\\x2dlabel-${hostname}.device"
    ];
    after = [
      "dev-disk-by\\x2dlabel-${hostname}.device"
      "systemd-cryptsetup@enc.service"
    ];
    before = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = "${rollback-script} ${disk}";
  };
}
