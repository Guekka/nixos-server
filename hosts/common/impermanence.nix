{
  config,
  pkgs,
  impermanence,
  ...
}: {
  imports = [
    impermanence.nixosModule
  ];

  # filesystems
  fileSystems."/".options = ["compress=zstd" "noatime"];
  fileSystems."/home".options = ["compress=zstd" "noatime"];
  fileSystems."/nix".options = ["compress=zstd" "noatime"];
  fileSystems."/persist".options = ["compress=zstd" "noatime"];
  fileSystems."/persist".neededForBoot = true;

  fileSystems."/var/log".options = ["compress=zstd" "noatime"];
  fileSystems."/var/log".neededForBoot = true;

  # source: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt

    mount -o subvol=/ /dev/sda3 /mnt

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

  # always persist these
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
