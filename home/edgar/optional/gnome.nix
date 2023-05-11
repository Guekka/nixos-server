{
  lib,
  pkgs,
  ...
}: let
  types = lib.hm.gvariant;
in {
  dconf = {
    enable = true;
    settings = {
      # ...
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "pop-launcher-super-key@ManeLippert"
          "pop-shell@system76.com"
        ];
        disabled-extensions = [
          "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/desktop/input-sources" = {
        sources = [
          (types.mkTuple ["xkb" "fr+oss_latin9"])
        ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        minimize = ["<Super>c"];
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        gap-outer = types.mkUint32 0;
        gap-inner = types.mkUint32 0;
        active-hint-border-radius = 0;
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "SolArc";
      package = pkgs.solarc-gtk-theme;
    };
  };
}
