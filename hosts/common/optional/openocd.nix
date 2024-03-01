{pkgs, ...}: {
  users.extraGroups.plugdev = {};
  users.extraUsers.edgar.extraGroups = ["plugdev" "dialout"];

  environment.systemPackages = [pkgs.openocd];
  services.udev.packages = [pkgs.openocd];
}
