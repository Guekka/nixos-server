{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # XDG Portals
  xdg = {
    portal = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.xdg-utils # xdg-open
  ];

  # Mostly from <https://www.reddit.com/r/NixOS/comments/137j18j/comment/ju6h25k/>
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1"; disable for now since vs code is broken
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
  };
}
