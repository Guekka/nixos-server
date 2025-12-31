{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.nixpkgs.nixosModules.notDetected
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];

  swapDevices = [
    {
      device = "/persist/nobackup/swapfile";
      size = 16384;
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
