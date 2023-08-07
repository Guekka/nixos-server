{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.nixpkgs.nixosModules.notDetected
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/02CB-C556";
      fsType = "vfat";
    };

    "/sandisk" = {
      device = "/dev/disk/by-uuid/bcfed9b2-8c80-4cf4-80b4-a6c1c221638d";
      fsType = "btrfs";
    };

    "/data" = {
      device = "/dev/disk/by-uuid/acbf6beb-7d17-407d-8ef0-3202477912fc";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/501790d1-e37a-48a1-a5d0-4efca5425526";}
  ];

  hardware.cpu.amd.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
