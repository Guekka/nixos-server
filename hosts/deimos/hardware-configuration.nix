{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-ideapad-15arh05
    inputs.nixpkgs.nixosModules.notDetected
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
  boot.kernelModules = ["kvm-amd" "nvidia" "nvidia-uvm"];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D632-F96F";
    fsType = "vfat";
  };

  swapDevices = [
    {
      # on /persist since / is tmpfs. It woudln't make sense to have a swapfile in tmpfs
      device = "/persist/swapfile";
      size = 8192;
    }
  ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime.reverseSync.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
