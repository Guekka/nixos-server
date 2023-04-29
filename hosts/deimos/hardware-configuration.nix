{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-ideapad-15arh05
    inputs.nixpkgs.nixosModules.notDetected
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
  boot.kernelModules = ["kvm-amd"];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D632-F96F";
    fsType = "vfat";
  };

  swapDevices = []; # TODO: add swap

  hardware.cpu.amd.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
