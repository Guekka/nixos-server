{pkgs, ...}: {
  programs.adb.enable = true;
  users.users.edgar.extraGroups = ["adbusers"];
  environment.systemPackages = with pkgs; [
    adbfs-rootless
  ];
}
