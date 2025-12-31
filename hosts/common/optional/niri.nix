{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
    ./fcitx.nix
  ];
  #
  xdg = {
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
    };
  };

  # <https://github.com/NixOS/nixpkgs/issues/19629>
  services.xserver.exportConfiguration = true;

  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };
  programs.xwayland.enable = true;

  services.gnome.gnome-keyring.enable = lib.mkForce false;

  # Mostly from <https://www.reddit.com/r/NixOS/comments/137j18j/comment/ju6h25k/>
  environment.sessionVariables =
    {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";
    }
    // lib.mkIf (builtins.elem "nvidia" config.boot.kernelModules) {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
}
