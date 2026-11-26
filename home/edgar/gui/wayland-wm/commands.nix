{
  config,
  lib,
  pkgs,
}: let
  hasInternalPanel = builtins.any (monitor: lib.hasPrefix "eDP-" monitor.name) config.monitors;

  brightnessctl = lib.getExe pkgs.brightnessctl;
  ddcutil = lib.getExe pkgs.ddcutil;
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";
  cliphist = lib.getExe pkgs.cliphist;
  rofiExe = lib.getExe config.programs.rofi.finalPackage;
  wlCopy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  darkmanExe = lib.getExe config.services.darkman.package;
  hyprlockExe = lib.getExe config.programs.hyprlock.package;
  playerctlExe = lib.getExe config.services.playerctld.package;
  playerctldExe = lib.getExe' config.services.playerctld.package "playerctld";
  socat = lib.getExe pkgs.socat;
in {
  terminal = config.home.sessionVariables.TERMINAL;
  browser = lib.getExe pkgs.firefox;
  albertToggle = ''echo -n '["toggle"]' | ${socat} - ~/.cache/albert/ipc_socket'';
  clipboardHistory = "${cliphist} list | ${rofiExe} -dmenu | ${cliphist} decode | ${wlCopy}";
  darkmanToggle = "${darkmanExe} toggle";
  lock = hyprlockExe;
  rofi = rofiExe;

  brightness = {
    inherit hasInternalPanel;
    up =
      if hasInternalPanel
      then "${brightnessctl} set 10%+"
      else "${ddcutil} setvcp 10 + 10";
    down =
      if hasInternalPanel
      then "${brightnessctl} set 10%-"
      else "${ddcutil} setvcp 10 - 10";
  };

  audio = {
    volumeUp = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
    volumeDown = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
    muteSink = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    muteSource = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
  };

  media = {
    playerctl = playerctlExe;
    playPause = "${playerctlExe} play-pause";
    next = "${playerctlExe} next";
    previous = "${playerctlExe} previous";
    stop = "${playerctlExe} stop";
    shift = "${playerctldExe} shift";
    unshift = "${playerctldExe} unshift";
  };
}
