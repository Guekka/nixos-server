{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [exiftool mediainfo mpv ripdrag]; # yazi uses these

  stylix.targets.yazi.enable = false; # status bar unreadable

  programs.yazi = {
    enable = true;
    package = pkgs.unstable.yazi;

    theme.flavor = {
      light = "flexoki-light";
      dark = "flexoki-dark";
    };

    flavors = {
      flexoki-light = inputs.yazi-flexoki-light;
      flexoki-dark = inputs.yazi-flexoki-dark;
    };

    enableBashIntegration = true;
    enableFishIntegration = true;

    plugins = {
      augment-command = "${inputs.yazi-augment-command}";
      chmod = "${inputs.yazi-plugins}/chmod.yazi";
      compress = "${inputs.yazi-compress}";
      git = "${inputs.yazi-plugins}/git.yazi";
      hexyl = "${inputs.yazi-hexyl}";
      toggle-pane = "${inputs.yazi-plugins}/toggle-pane.yazi";
      mount = "${inputs.yazi-plugins}/mount.yazi";
      what-size = "${inputs.yazi-what-size}";
    };

    initLua = ''
      -- Custom configuration for augment-command
      require("augment-command"):setup({
        smart_paste = true,
        smart_tab_create = true,
      })

      -- Makes yazi update the zoxide database on navigation
      require("zoxide"):setup
      {
        update_db = true,
      }
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "p";
          run = "plugin augment-command -- paste";
          desc = "Smart paste yanked files";
        }
        {
          on = "t";
          run = "plugin augment-command -- tab_create --current";
          desc = "Create a new tab with smart directory";
        }
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
          on = ["M"];
          run = "plugin mount";
          desc = "Mount mgr";
        }
        {
          on = ["T"];
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore preview";
        }
        {
          on = ["." "s"];
          run = "plugin what-size --args='--clipboard'";
          desc = "Calc size of selection or cwd";
        }
        {
          on = "C-n";
          run = ''shell -- ripdrag -xna "$1"'';
          desc = "ripdrag";
        }
      ];
    };

    settings = {
      tasks = {
        image_bound = [10000 10000];
      };
      mgr = {
        show_hidden = true;
        sort_dir_first = false;
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
