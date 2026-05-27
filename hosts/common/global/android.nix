{pkgs, ...}: {
  users.users.edgar.extraGroups = ["adbusers"];
  environment.systemPackages = with pkgs; [
    adbfs-rootless
    android-tools
  ];
}
