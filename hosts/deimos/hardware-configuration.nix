{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-ideapad-15arh05
    inputs.nixpkgs.nixosModules.notDetected
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
  boot.kernelModules = ["kvm-amd" "nvidia_modeset" "nvidia" "nvidia_uvm"];
  # seems to fix instability
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D632-F96F";
    fsType = "vfat";
  };

  swapDevices = [
    {
      # on /persist since / is tmpfs. It woudln't make sense to have a swapfile in tmpfs
      device = "/persist/swapfile";
      size = 16384;
    }
  ];

  hardware.cpu.amd.updateMicrocode = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # should hopefully reduce power usage
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # this makes hdmi work
    prime.reverseSync.enable = true;

    # supposed to help with wayland compositor
    modesetting.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
