{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    unstable.pop-launcher # not yet stabilized
    gnomeExtensions.pop-shell
    gnomeExtensions.pop-launcher-super-key
  ];
}
