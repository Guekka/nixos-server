#!/usr/bin/env sh

set -eu

mkdir -p /mnt

# Mount the btrfs root to /mnt for subvolume manipulation
echo "Mounting $1"
mount -o subvol=/,user_subvol_rm_allowed "$1" /mnt
trap 'umount /mnt' EXIT

# Rotate old snapshots
echo "Rotating snapshots..."

if [ -d "/mnt/root-snapshot-3" ]; then
  btrfs subvolume delete -R /mnt/root-snapshot-3
fi

if [ -d "/mnt/root-snapshot-2" ]; then
  mv "/mnt/root-snapshot-2" "/mnt/root-snapshot-3"
fi

if [ -d "/mnt/root-snapshot-1" ]; then
  mv "/mnt/root-snapshot-1" "/mnt/root-snapshot-2"
fi

echo "Snapshotting current root"
if [ -d "/mnt/root" ]; then
  btrfs subvolume snapshot /mnt/root /mnt/root-snapshot-1
  btrfs subvolume delete -R /mnt/root
fi

echo "Restoring blank /mnt/root subvolume..."
if [ ! -d "/mnt/root" ]; then
  btrfs subvolume create /mnt/root
fi

echo "Rollback complete"
