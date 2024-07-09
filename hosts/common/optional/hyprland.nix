{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
  };

  # XDG Portals
  xdg = {
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-kde];
    };
  };

  environment.systemPackages = [
    pkgs.xdg-utils # xdg-open
  ];

  # Mostly from <https://www.reddit.com/r/NixOS/comments/137j18j/comment/ju6h25k/>
  environment.sessionVariables =
    {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";
    }
    // lib.mkIf (config.hardware.nvidia.package != null) {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
}
