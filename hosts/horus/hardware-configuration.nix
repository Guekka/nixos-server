{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/483d59c7-c1f0-4546-8496-9abfed7516f7";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/483d59c7-c1f0-4546-8496-9abfed7516f7";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/483d59c7-c1f0-4546-8496-9abfed7516f7";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/483d59c7-c1f0-4546-8496-9abfed7516f7";
    fsType = "btrfs";
    options = ["subvol=persist"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/483d59c7-c1f0-4546-8496-9abfed7516f7";
    fsType = "btrfs";
    options = ["subvol=log"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9D4E-2BFF";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/bf3423d7-cf39-4fa5-b0cb-28991a364b7c";}
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
