{
  config,
  lib,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  rollback-script = pkgs.writeShellScript "btrfs-rollback-script" (builtins.readFile ./btrfs-rollback-script.sh);
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

    postResumeCommands = lib.mkAfter ''echo "Executing rollback script" && ${rollback-script} /dev/disk/by-label/${hostname}'';
  };
}
