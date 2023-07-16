{
  config,
  lib,
  inputs,
  ...
}: let
  hostname = config.networking.hostName;
  disk = "/dev/disk/by-label/${hostname}";
in {
  imports = [
    inputs.impermanence.nixosModule
  ];

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

  # source: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
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
    script = ''
      mkdir -p /mnt

      mount -o subvol=/ ${disk} /mnt

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

      umount /mnt
    '';
  };

  # always persist these
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
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
