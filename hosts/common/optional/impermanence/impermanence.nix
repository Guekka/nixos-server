{
  config,
  utils,
  ...
}: let
  hostname = config.networking.hostName;
in {
  imports = [./impermanence-common.nix];
  disko.devices = {
    disk.main = {
      type = "disk";

      content = {
        type = "gpt";
        partitions = {
          boot = {
            priority = 1;
            name = "boot";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          data = {
            size = "100%";
            content = {
              type = "btrfs";
              # label partition
              extraArgs = "-L${hostname}";
              subvolumes = {
                root = {
                  type = "filesystem";
                  mountpoint = "/";
                  mountOptions = ["compress=zstd"];
                };
                nix = {
                  type = "filesystem";
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                persist = {
                  type = "filesystem";
                  mountpoint = "/persist";
                  mountOptions = ["compress=zstd"];
                };
                log = {
                  type = "filesystem";
                  mountpoint = "/var/log";
                  mountOptions = ["compress=zstd"];
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  boot.initrd = {
    enable = true;
    supportedFilesystems = ["btrfs"];

    systemd.services.persisted-files = {
      description = "Rollback Btrfs root subvolume";
      unitConfig.DefaultDependencies = false;
      requires = [
        "${utils.escapeSystemdPath "/dev/disk/by-label/${hostname}"}.device"
      ];
      after = [
        "${utils.escapeSystemdPath "/dev/disk/by-label/${hostname}"}.device"
        "local-fs-pre.target"
      ];
      before = [
        "sysroot.mount"
      ];
      requiredBy = [
        "initrd.target"
      ];
      serviceConfig.Type = "oneshot";
      serviceConfig.StandardOutput = "journal+console";
      serviceConfig.StandardError = "journal+console";

      script = ''
        set -eu

        echo "Executing rollback script"
        mkdir -p /mnt

        # Mount the btrfs root to /mnt for subvolume manipulation
        disk=/dev/disk/by-label/${hostname}
        echo "Mounting $disk"
        mount -o subvol=/,user_subvol_rm_allowed "$disk" /mnt

        # Rotate old snapshots
        echo "Rotating snapshots..."

        [ -d "/mnt/root-snapshot-3" ] && btrfs subvolume delete -R /mnt/root-snapshot-3 || true
        [ -d "/mnt/root-snapshot-2" ] && mv "/mnt/root-snapshot-2" "/mnt/root-snapshot-3"
        [ -d "/mnt/root-snapshot-1" ] && mv "/mnt/root-snapshot-1" "/mnt/root-snapshot-2"

        echo "Snapshotting current root"
        if [ -d /mnt/root ]; then
          btrfs subvolume snapshot /mnt/root /mnt/root-snapshot-1
          btrfs subvolume delete -R /mnt/root || true
        fi

        echo "Restoring blank /mnt/root subvolume..."
        if [ ! -d /mnt/root ]; then
          btrfs subvolume create /mnt/root
        fi

        echo "Unmounting /mnt..."
        umount /mnt

        echo "Rollback complete"
      '';
    };
  };
}
