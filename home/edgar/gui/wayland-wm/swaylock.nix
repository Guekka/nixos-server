{
  programs.swaylock = {
    enable = true;
    settings = {
      screenshots = true;
      clock = true;

      effect-blur = "20x3";
      fade-in = 0.1;

      line-uses-inside = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 60;
      indicator-idle-visible = true;
      indicator-y-position = 1000;
    };
  };
}
