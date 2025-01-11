# TODO: merge this with impermanence.nix
{lib, ...}: {
  imports = [./impermanence-common.nix];

  disko.devices = {
    # tmpfs on root
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "defaults"
        "mode=0755"
      ];
    };

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
                home = {
                  type = "filesystem";
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd"];
                };
                nix = {
                  type = "filesystem";
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd"];
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
}
