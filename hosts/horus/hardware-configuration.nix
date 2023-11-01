{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod"];

  swapDevices = [
    {
      # on /persist since / is tmpfs. It woudln't make sense to have a swapfile in tmpfs
      device = "/persist/swapfile";
      size = 8192;
    }
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableAllFirmware = true;
}
