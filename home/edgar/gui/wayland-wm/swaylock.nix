{config, ...}: let
  inherit (config.colorscheme) palette;
in {
  programs.swaylock = {
    enable = true;
    settings = {
      screenshots = true;
      clock = true;

      effect-blur = "20x3";
      fade-in = 0.1;

      font = config.fontProfiles.regular.family;
      font-size = 15;

      line-uses-inside = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 60;
      indicator-idle-visible = true;
      indicator-y-position = 1000;

      ring-color = "#${palette.base02}";
      inside-wrong-color = "#${palette.base08}";
      ring-wrong-color = "#${palette.base08}";
      key-hl-color = "#${palette.base0B}";
      bs-hl-color = "#${palette.base08}";
      ring-ver-color = "#${palette.base09}";
      inside-ver-color = "#${palette.base09}";
      inside-color = "#${palette.base01}";
      text-color = "#${palette.base07}";
      text-clear-color = "#${palette.base01}";
      text-ver-color = "#${palette.base01}";
      text-wrong-color = "#${palette.base01}";
      text-caps-lock-color = "#${palette.base07}";
      inside-clear-color = "#${palette.base0C}";
      ring-clear-color = "#${palette.base0C}";
      inside-caps-lock-color = "#${palette.base09}";
      ring-caps-lock-color = "#${palette.base02}";
      separator-color = "#${palette.base02}";
    };
  };
}
