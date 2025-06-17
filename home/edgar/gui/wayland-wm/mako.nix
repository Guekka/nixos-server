{pkgs, ...}: {
  home.packages = [pkgs.libnotify];
  services.mako = {
    enable = true;

    settings = {
      padding = "10,20";
      anchor = "top-center";
      width = 400;
      height = 150;
      default-timeout = 6000;
      layer = "overlay";
    };
  };
}
