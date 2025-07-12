{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with config.lib.stylix.colors; let
  default-background = base00;
  default-foreground = base05;
  light-foreground = base06;
  light-background = base07;

  binds = {
    suffixes,
    prefixes,
    substitutions ? {},
  }: let
    replacer = lib.replaceStrings (lib.attrNames substitutions) (lib.attrValues substitutions);
    format = prefix: suffix: let
      actual-suffix =
        if lib.isList suffix.action
        then {
          action = lib.head suffix.action;
          args = lib.tail suffix.action;
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
      lib.concatMap (
        key:
          fn {
            inherit key;
            action = attrs.${key};
          }
      ) (lib.attrNames attrs);
  in
    lib.listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));

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

  playerctl = lib.getExe pkgs.playerctl;
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  terminal = config.home.sessionVariables.TERMINAL;
  browser = lib.getExe pkgs.firefox;
  hyprlock = lib.getExe pkgs.hyprlock;
  darkman = "${pkgs.darkman}/bin/darkman";
  cliphist = lib.getExe pkgs.cliphist;
in {
  imports = [
    inputs.niri.homeModules.stylix
    ../wayland-wm
  ];

  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "fr,fr";
      focus-follows-mouse.enable = true;
      warp-mouse-to-focus.enable = true;
    };

    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in
      lib.attrsets.mergeAttrsList [
        {
          # Apps
          "Mod+Return".action = spawn terminal;
          "Mod+D".action = sh "echo -n toggle | ${socat} - ~/.cache/albert/ipc_socket";
          "Mod+X".action = sh "${killall} -SIGUSR1 .waybar-wrapped";
          "Mod+C".action = sh "${cliphist} list | ${rofi} -dmenu | ${cliphist} decode | ${wl-copy}";
          "Mod+W".action = sh "${swaync-client} -t";
          "Mod+B".action = sh browser;
          "Mod+Shift+T".action = sh "${darkman} toggle";
          "Mod+Backspace".action = spawn hyprlock;
        }
        {
          # Functions
          "XF86AudioPlay".action = sh "${playerctl} play-pause";
          "XF86AudioRaiseVolume".action = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
          "XF86AudioLowerVolume".action = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          "XF86AudioMute".action = sh "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86MonBrightnessUp".action = sh "${brightnessctl} set 10%+";
          "XF86MonBrightnessDown".action = sh "${brightnessctl} set 10%-";

          "Print".action = screenshot;
          "Mod+Print".action = screenshot-window;
          "Alt+Print".action = screenshot-window;
        }
        {
          # Other
          "Mod+colon".action = show-hotkey-overlay;
          "Mod+Shift+Q".action = close-window;
        }
        # Window binds
        (binds {
          suffixes = {
            "Left" = "column-left";
            "Down" = "window-down";
            "Up" = "window-up";
            "Right" = "column-right";
            "H" = "column-left";
            "J" = "window-down";
            "K" = "window-up";
            "L" = "column-right";
          };

          prefixes = {
            "Mod" = "focus";
            "Mod+Shift" = "move";
            "Mod+Alt" = "focus-monitor";
            "Mod+Shift+Alt" = "move-window-to-monitor";
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
            }) (lib.range 1 9)
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
          "Mod+Space".action = toggle-column-tabbed-display;
          "Mod+C".action = center-column;

          # Resize columns
          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+Ctrl+R".action = reset-window-height;
          "Mod+Ctrl+F".action = expand-column-to-available-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;

          "Mod+KP_Subtract".action = set-column-width "-10%";
          "Mod+KP_Add".action = set-column-width "+10%";
          "Mod+Shift+KP_Subtract".action = set-window-height "-10%";
          "Mod+Shift+KP_Add".action = set-window-height "+10%";

          "Mod+A".action = toggle-overview;
          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
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
            from = default-foreground;
            to = light-foreground;
            angle = 45;
            relative-to = "workspace-view";
          };
        };
        inactive = {
          gradient = {
            from = default-background;
            to = light-background;
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
    overview = {
      backdrop-color = "#000000";
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
          inherit scale;
        };
      })
      config.monitors
    );
    window-rules = [
      {
        matches = [];
        geometry-corner-radius = {
          bottom-left = 12.0;
          bottom-right = 12.0;
          top-left = 12.0;
          top-right = 12.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [
          {
            title = "Albert";
          }
        ];
        border.enable = false;
      }
    ];
    environment = {
      DISPLAY = ":0";
      NIXOS_OZONE_WL = "1";
    };
    spawn-at-startup = let
      withCommand = command-to-run: {
        command = [
          command-to-run
        ];
      };
    in [
      (withCommand (lib.getExe pkgs.albert))
      (withCommand (lib.getExe pkgs.keepassxc))
      (withCommand (lib.getExe pkgs.beeper))
      (withCommand (lib.getExe pkgs.xwayland-satellite))
      (withCommand (lib.getExe pkgs.waybar))
    ];
  };

  xdg.portal = {
    enable = true;
    config.common.default = ["gtk" "gnome"];
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
