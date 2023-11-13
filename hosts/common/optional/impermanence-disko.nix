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
    # tmpfs on root
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
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

  # always persist these
  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
