# from <https://github.com/gvolpe/nix-config/blob/master/home/programs/hyprlock/default.nix>
{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
         general {
             hide_cursor=true
         }

         background {
             monitor =
             path = screenshot

             blur_passes = 2
             blur_size = 7
             noise = 0.0117
             contrast = 0.8916
             brightness = 0.8172
             vibrancy = 0.1696
             vibrancy_darkness = 0.0
         }

         label {
             monitor =
             # take a screenshot of the screen lock
             text = Enter your password, $USER
             color = rgba(200, 200, 200, 1.0)
             font_size = 25
             font_family = Noto Sans
             rotate = 0 # degrees, counter-clockwise

             position = 0, 180
             halign = center
             valign = center
         }
      }
    '';
  };
}
