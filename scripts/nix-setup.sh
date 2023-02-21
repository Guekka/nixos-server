DISK=/dev/vda

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
parted "$DISK" -- set 1 boot on
mkfs.vfat "$DISK"1

# As I intend to use this VM on Proxmox, I will not encrypt the disk

parted "$DISK" -- mkpart Swap linux-swap 1GiB 9GiB
mkswap -L Swap "$DISK"2
swapon "$DISK"2

parted "$DISK" -- mkpart primary 9GiB 100%
mkfs.btrfs -L Butter "$DISK"3

mount "$DISK"3 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log

# We then take an empty *readonly* snapshot of the root subvolume,
# which we'll eventually rollback to on every boot.
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

# Mount the directories

mount -o subvol=root,compress=zstd,noatime "$DISK"3 /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime "$DISK"3 /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime "$DISK"3 /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime "$DISK"3 /mnt/persist

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime "$DISK"3 /mnt/var/log

# don't forget this!
mkdir /mnt/boot
mount "$DISK"1 /mnt/boot

# create configuration
nixos-generate-config --root /mnt

# now, edit nixos configuration and nixos-install
