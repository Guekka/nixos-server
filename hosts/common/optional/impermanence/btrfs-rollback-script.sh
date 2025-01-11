#!/usr/bin/env sh

mkdir -p /mnt

# Mount the btrfs root to /mnt for subvolume manipulation
echo "Mouting $1"
mount -o subvol=/,user_subvol_rm_allowed "$1" /mnt

# Rotate old snapshots
echo "Rotating snapshots..."

[ -d "/mnt/root-snapshot-3" ] && btrfs subvolume delete -R /mnt/root-snapshot-3
[ -d "/mnt/root-snapshot-2" ] && mv "/mnt/root-snapshot-2" "/mnt/root-snapshot-3"
[ -d "/mnt/root-snapshot-1" ] && mv "/mnt/root-snapshot-1" "/mnt/root-snapshot-2"

echo "Snapshotting current root"
btrfs subvolume snapshot /mnt/root /mnt/root-snapshot-1

btrfs subvolume delete -R /mnt/root

echo "Restoring blank /mnt/root subvolume..."
btrfs subvolume create /mnt/root

echo "Unmounting /mnt..."
umount /mnt

echo "Rollback complete"
