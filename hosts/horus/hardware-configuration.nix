{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod"];

  swapDevices = {
    "/swapfile" = {
      size = 8192;
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableAllFirmware = true;
}
