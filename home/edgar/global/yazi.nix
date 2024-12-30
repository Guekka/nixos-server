{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [exiftool mediainfo mpv]; # yazi uses these for preview
  programs.yazi = {
    enable = true;
    package = pkgs.unstable.yazi;

    enableBashIntegration = true;
    enableFishIntegration = true;

    plugins = {
      chmod = "${inputs.yazi-plugins}/chmod.yazi";
      compress = "${inputs.yazi-compress}";
      git = "${inputs.yazi-plugins}/git.yazi";
      hexyl = "${inputs.yazi-hexyl}";
      max-preview = "${inputs.yazi-plugins}/max-preview.yazi";
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = ["c" "a"];
          run = "plugin compress";
          desc = "Compress file";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Change file permissions";
        }
        {
          on = ["T"];
          run = "plugin max-preview";
          desc = "Maximize or restore preview";
        }
      ];
    };

    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 2560;
        max_height = 1440;
      };
      plugin = {
        append_previewers = [
          {
            name = "*";
            run = "hexyl";
          }
        ];
      };
    };
  };
}
