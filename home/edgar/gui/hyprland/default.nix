{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../wayland-wm

    ./tty-init.nix
    ./basic-binds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      env = [
        "NIXOS_OZONE_WL,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 3;
        layout = "dwindle";
      };
      input = {
        kb_layout = "fr,us";
        kb_options = "numpad:mac"; # make numpad always work as numbers
        numlock_by_default = true;
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      dwindle = {
        split_width_multiplier = 1.35;
        no_gaps_when_only = 1;
        special_scale_factor = 0.9;
      };

      misc = {
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
        vfr = "on";
        focus_on_activate = true;
      };

      decoration = {
        active_opacity = 0.99;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;
        rounding = 5;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        drop_shadow = true;
        shadow_range = 12;
        shadow_offset = "3 3";
      };
      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeout,0.5, 1, 0.89, 1"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeoutback,0.34, 1.56, 0.64, 1"
        ];

        animation = [
          "windowsIn,1,3,easeoutback,slide"
          "windowsOut,1,3,easeinback,slide"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2,easeoutback,slide"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeSwitch,1,3,easeout"
          "fadeShadow,1,3,easeout"
          "fadeDim,1,3,easeout"
          "border,1,3,easeout"
        ];
      };

      exec-once = [
        "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      ];

      windowrule = [
        # League of legends
        "float,title:League of Legends"
      ];

      windowrulev2 = [
        "workspace 3, class:^(org.keepassxc.KeePassXC)$"

        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
      binde = let
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
      in [
        # Brightness
        ",XF86MonBrightnessUp,exec,${brightnessctl} set +5%"
        ",XF86MonBrightnessDown,exec,${brightnessctl} set 5%-"
        # Volume
        ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
        ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ];
      bind = let
        cliphist = "${pkgs.cliphist}/bin/cliphist";
        hyprlock = lib.getExe config.programs.hyprlock.package;
        playerctl = "${config.services.playerctld.package}/bin/playerctl";
        playerctld = "${config.services.playerctld.package}/bin/playerctld";
        makoctl = "${config.services.mako.package}/bin/makoctl";
        rofi = lib.getExe config.programs.rofi.finalPackage;
        pass-wofi = "${pkgs.pass-wofi.override {
          pass = config.programs.password-store.package;
        }}/bin/pass-wofi";
        systemctl = "${pkgs.systemd}/bin/systemctl";
        wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";

        grimblast = "${pkgs.grimblast}/bin/grimblast";
        # TODO tly = "${pkgs.tly}/bin/tly";
        # gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
        # notify-send = "${pkgs.libnotify}/bin/notify-send";

        gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

        terminal = config.home.sessionVariables.TERMINAL;
        browser = defaultApp "x-scheme-handler/https";
        editor = defaultApp "text/plain";
      in
        [
          # Program bindings
          "SUPER,Return,exec,${terminal}"
          "SUPER,e,exec,${editor}"
          "SUPER,v,exec,${editor}"
          "SUPER,b,exec,${browser}"
          # Screenshotting
          ",Print,exec,${grimblast} --notify --freeze copy area"
          "SHIFT,Print,exec,${grimblast} --notify --freeze copy active"
          "CONTROL,Print,exec,${grimblast} --notify --freeze copy screen"
          "SUPER,Print,exec,${grimblast} --notify --freeze copy window"
          "ALT,Print,exec,${grimblast} --notify --freeze copy output"
          # Power button
          ",xf86poweroff,exec,${systemctl} suspend"
          "SUPER,xf86poweroff,exec,${systemctl} poweroff"
          # Tally counter
          # TODO "SUPER,z,exec,${notify-send} -t 1000 $(${tly} time) && ${tly} add && ${gtk-play} -i dialog-information" # Add new entry
          # TODO "SUPERCONTROL,z,exec,${notify-send} -t 1000 $(${tly} time) && ${tly} undo && ${gtk-play} -i dialog-warning" # Undo last entry
          # TODO "SUPERCONTROLSHIFT,z,exec,${tly} reset && ${gtk-play} -i complete" # Reset
          # TODO "SUPERSHIFT,z,exec,${notify-send} -t 1000 $(${tly} time)" # Show current time
        ]
        ++ (lib.optionals config.services.playerctld.enable [
          # Media control
          ",XF86AudioNext,exec,${playerctl} next"
          ",XF86AudioPrev,exec,${playerctl} previous"
          ",XF86AudioPlay,exec,${playerctl} play-pause"
          ",XF86AudioStop,exec,${playerctl} stop"
          "ALT,XF86AudioNext,exec,${playerctld} shift"
          "ALT,XF86AudioPrev,exec,${playerctld} unshift"
          "ALT,XF86AudioPlay,exec,systemctl --user restart playerctld"
        ])
        ++
        # Screen lock
        (lib.optionals config.programs.hyprlock.enable [
          ",XF86Launch5,exec,${hyprlock}"
          ",XF86Launch4,exec,${hyprlock}"
          "SUPER,backspace,exec,${hyprlock}"
        ])
        ++
        # Notification manager
        (lib.optionals config.services.mako.enable [
          "SUPER,w,exec,${makoctl} dismiss"
        ])
        ++
        # Launcher
        (lib.optionals config.programs.rofi.enable [
            "SUPER,d,exec,${rofi} -show combi -sidebar-mode"
            "SUPERSHIFT,x,exec,${rofi} -show run"
            "SUPER,tab,exec,${rofi} -show window"
          ]
          ++ (lib.optionals config.services.cliphist.enable [
            "SUPER, c, exec, ${cliphist} list | ${rofi} -dmenu | ${cliphist} decode | ${wl-copy}" # Clipboard manager
          ])
          ++ (lib.optionals config.programs.password-store.enable [
            ",Scroll_Lock,exec,${pass-wofi}" # fn+k
            ",XF86Calculator,exec,${pass-wofi}" # fn+f12
            "SUPER,semicolon,exec,pass-wofi"
          ]));

      monitor =
        map (
          m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name},${
            if m.enabled
            then "${resolution},${position},1"
            else "disable"
          }"
        )
        config.monitors
        ++ [
          ",preferred,auto,1"
          "FALLBACK,1920x1080@60,auto,1"
        ];

      workspace = map (
        m: "${m.name},${m.workspace}"
      ) (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
    };

    # This is order sensitive, so it has to come here.
    extraConfig = ''
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };
}
