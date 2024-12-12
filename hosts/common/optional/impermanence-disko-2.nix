# TODO: this file should replace impermanence.nix
# But it involves repartiotioning the disk, so it's only used for new hosts
{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModule
  ];

  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/sda";
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
              subvolumes = {
                root = {
                  type = "filesystem";
                  mountpoint = "/";
                  mountOptions = ["compress=zstd"];
                };
                home = {
                  type = "filesystem";
                  mountpoint = "/home";
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
                shared = {
                  type = "filesystem";
                  mountpoint = "/shared";
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

    postResumeCommands = lib.mkAfter ''
      mkdir -p /mnt
      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/vda3 /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };

  # always persist these
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
