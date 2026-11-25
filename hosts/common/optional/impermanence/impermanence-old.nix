{
  config,
  pkgs,
  utils,
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

  boot.initrd = {
    enable = true;
    supportedFilesystems = ["btrfs"];

    systemd.services.persisted-files = {
      description = "Rollback Btrfs root subvolume";
      unitConfig.DefaultDependencies = false;
      requires = [
        "${utils.escapeSystemdPath disk}.device"
      ];
      after = [
        "${utils.escapeSystemdPath disk}.device"
        "local-fs-pre.target"
        "systemd-hibernate-resume.service"
      ];
      before = ["sysroot.mount"];
      requiredBy = ["initrd.target"];
      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
      script = ''
        set -eu
        echo "Executing rollback script"
        ${rollback-script} ${disk}
      '';
    };
  };
}
