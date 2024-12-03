# TODO: this file should replace impermanence.nix
# But it involves repartiotioning the disk, so it's only used for new hosts
# Source: https://yomaq.github.io/posts/zfs-encryption-backups-and-convenience/
{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModule
  ];

  boot = {
    supportedFilesystems = ["zfs"];
    kernelParams = [
      "nohibernate"
      "zfs.zfs_arc_max=17179869184"
    ];
  };
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  #
  # always persist these
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  boot.initrd = {
    enable = true;
    supportedFilesystems = ["zfs"];

    postResumeCommands = lib.mkAfter ''
      zfs rollback -r zroot/root@blank
    '';
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  disko.devices = {
    disk = {
      a = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          zfs_fs = {
            type = "zfs_fs";
            mountpoint = "/zfs_fs";
            options."com.sun:auto-snapshot" = "true";
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "false";
          };
          # Nix store etc. Needs to persist, but doesn't need backed up
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "false";
            };
          };
          # Where everything else lives, and is wiped on reboot by restoring a blank zfs snapshot.
          root = {
            type = "zfs_fs";
            options."com.sun:auto-snapshot" = "false";
            mountpoint = "/";
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
