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

    postResumeCommands = lib.mkAfter ''echo "Executing rollback script" && ${rollback-script} ${disk}'';
  };
}
