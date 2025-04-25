{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib; let
  binds = {
    suffixes,
    prefixes,
    substitutions ? {},
  }: let
    replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
    format = prefix: suffix: let
      actual-suffix =
        if isList suffix.action
        then {
          action = head suffix.action;
          args = tail suffix.action;
        }
        else {
          inherit (suffix) action;
          args = [];
        };

      action = replacer "${prefix.action}-${actual-suffix.action}";
    in {
      name = "${prefix.key}+${suffix.key}";
      value.action.${action} = actual-suffix.args;
    };
    pairs = attrs: fn:
      concatMap (
        key:
          fn {
            inherit key;
            action = attrs.${key};
          }
      ) (attrNames attrs);
  in
    listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));

  azerty = {
    "1" = "ampersand";
    "2" = "eacute";
    "3" = "quotedbl";
    "4" = "apostrophe";
    "5" = "parenleft";
    "6" = "minus";
    "7" = "egrave";
    "8" = "underscore";
    "9" = "ccedilla";
    "0" = "agrave";
  };

  toAzerty = n: set:
    if (builtins.elem n (lib.attrNames set))
    then set.${n}
    else n;
  socat = lib.getExe pkgs.socat;
  killall = "${pkgs.killall}/bin/killall";
  brightnessctl = lib.getExe pkgs.brightnessctl;
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";

  terminal = config.home.sessionVariables.TERMINAL;
  hyprlock = lib.getExe pkgs.hyprlock;
  darkman = "${pkgs.darkman}/bin/darkman";
in {
  imports = [
    ../wayland-wm
    inputs.niri.homeModules.niri
  ];

  programs.niri.enable = true;
  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "fr,fr";
      focus-follows-mouse.enable = true;
    };
    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in
      lib.attrsets.mergeAttrsList [
        {
          # Apps
          "Mod+T".action = spawn terminal;
          "Mod+D".action = sh "echo -n toggle | ${socat} - ~/.cache/albert/ipc_socket";
          "Mod+x".action = sh "${killall} -SIGUSR1 .waybar-wrapped";
          "Mod+Shift+T".action = sh "${darkman} toggle";
          "Mod+Backspace".action = spawn hyprlock;
        }
        {
          # Functions
          "XF86AudioRaiseVolume".action = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
          "XF86AudioLowerVolume".action = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          "XF86AudioMute".action = sh "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86MonBrightnessUp".action = sh "${brightnessctl} set 10%+";
          "XF86MonBrightnessDown".action = sh "${brightnessctl} set 10%-";

          "Print".action = screenshot;
          "Alt+Print".action = screenshot-window;
        }
        {
          # Other
          "Mod+colon".action = show-hotkey-overlay;
          "Mod+Q".action = close-window;
        }
        # Window binds
        (binds {
          suffixes = {
            "Left" = "column-left";
            "Down" = "window-down";
            "Up" = "window-up";
            "Right" = "column-right";
            "J" = "column-left";
            "K" = "window-down";
            "L" = "window-up";
            "M" = "column-right";
          };

          prefixes = {
            "Mod" = "focus";
            "Mod+Ctrl" = "move";
            "Mod+Shift" = "focus-monitor";
            "Mod+Shift+Ctrl" = "move-window-to-monitor";
          };
          substitutions = {
            "monitor-column" = "monitor";
            "monitor-window" = "monitor";
          };
        })
        {
          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
        }
        (binds {
          suffixes = {
            "Home" = "first";
            "End" = "last";
          };
          prefixes = {
            "Mod" = "focus-column";
            "Mod+Ctrl" = "move-column-to";
          };
        })
        (binds {
          suffixes = {
            "U" = "workspace-down";
            "Page_Down" = "workspace-down";
            "WheelScrollDown" = "workspace-down";
            "I" = "workspace-up";
            "WheelScrollUp" = "workspace-up";
            "Page_Up" = "workspace-up";
          };
          prefixes = {
            "Mod" = "focus";
            "Mod+Ctrl" = "move-window-to";
            "Mod+Shift" = "move";
          };
        })
        (binds {
          suffixes = builtins.listToAttrs (
            map (n: {
              name = toString (toAzerty (toString n) azerty);
              value = [
                "workspace"
                n
              ];
            }) (range 1 9)
          );
          prefixes = {
            "Mod" = "focus";
            "Mod+Ctrl" = "move-window-to";
          };
        })
        {
          # Move columns
          "Mod+Comma".action = consume-window-into-column;
          "Mod+semicolon".action = expel-window-from-column;
          "Mod+V".action = toggle-column-tabbed-display;
          "Mod+C".action = center-column;

          # Resize columns
          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+Ctrl+R".action = reset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+Ctrl+F".action = expand-column-to-available-width;

          "Mod+KP_Subtract".action = set-column-width "-10%";
          "Mod+KP_Add".action = set-column-width "+10%";
          "Mod+Shift+KP_Subtract".action = set-window-height "-10%";
          "Mod+Shift+KP_Add".action = set-window-height "+10%";

          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
        }
        {
          "Mod+Ctrl+F".action = expand-column-to-available-width;
        }
      ];

    layout = {
      gaps = 8;

      struts = {
        top = -8; # removes gap
        bottom = -8;
        left = 64;
        right = 64;
      };
      always-center-single-column = true;
      center-focused-column = "on-overflow";
      empty-workspace-above-first = true;

      preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
      ];

      default-column-width = {
        proportion = 1.0 / 2.0;
      };

      border = {
        enable = true;
        width = 6;
        active = {
          gradient = {
            from = "#AFEEEE";
            to = "#1E98FF";
            angle = 45;
            relative-to = "workspace-view";
          };
        };

        inactive = {
          gradient = {
            from = "#585b70";
            to = "#7f849c";
            angle = 45;
            relative-to = "workspace-view";
          };
        };
      };

      tab-indicator = {
        position = "top";
        gaps-between-tabs = 10;
        place-within-column = true;
      };
    };
    outputs = builtins.listToAttrs (
      map (m: {
        inherit (m) name;
        value = with m; {
          enable = enabled;
          background-color = "#000000";
          mode = {
            inherit width;
            inherit height;
            refresh = refreshRate;
          };
          position = {
            inherit x;
            inherit y;
          };
          scale = m.scale or 1;
        };
      })
      config.monitors
    );
    environment = {
      DISPLAY = ":0";
    };
    spawn-at-startup = let
      get-wayland-display = "systemctl --user show-environment | awk -F 'WAYLAND_DISPLAY=' '{print $2}' | awk NF";
      wrapper = name: op:
        pkgs.writeScript "${name}" ''
          if [ "$(${get-wayland-display})" ${op} "$WAYLAND_DISPLAY" ]; then
            exec "$@"
          fi
        '';

      only-without-session = wrapper "only-without-session" "!=";
    in [
      {
        command = [
          "${only-without-session}"
          (lib.getExe pkgs.waybar)
        ];
      }
      {
        command = [
          "${only-without-session}"
          (lib.getExe pkgs.albert)
        ];
      }
      {
        command = [
          "${only-without-session}"
          (lib.getExe pkgs.hypridle)
        ];
      }
      {
        command = [
          (lib.getExe pkgs.xwayland-satellite)
        ];
      }
    ];
  };
}
