{
  pkgs,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.hardware.nixosModules.common-gpu-amd
  ];

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod"];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9D4E-2BFF";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/bf3423d7-cf39-4fa5-b0cb-28991a364b7c";}
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableAllFirmware = true;
  hardware.opengl = {
    driSupport = true;
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      amdvlk
    ];
  };
}
