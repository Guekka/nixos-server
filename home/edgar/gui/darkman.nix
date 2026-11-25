{
  config,
  lib,
  pkgs,
  ...
}: {
  services.darkman = let
    find-hm-generation = let
      home-manager = lib.getExe pkgs.home-manager;
      grep = lib.getExe' pkgs.toybox "grep";
      head = lib.getExe' pkgs.toybox "head";
      find = lib.getExe' pkgs.toybox "find";
    in ''
      for generation in $(${home-manager} generations | ${grep} -o '/[^[:space:]]*')
      do
        specialisation="$(${find} "$generation" -type d -name specialisation -print | ${head} -1)"
        if [[ -n "$specialisation" ]]; then
          printf '%s\n' "$specialisation"
          exit 0
        fi
      done
      echo "Unable to find a Home Manager specialisation directory" >&2
      exit 1
    '';

    switch-theme-script = let
      cat = lib.getExe' pkgs.coreutils "cat";
      killall = lib.getExe pkgs.killall;
      albert = lib.getExe pkgs.albert;
      specialisation-marker = "${config.xdg.dataHome}/home-manager/specialisation";
    in
      theme: ''
        if [[ -e ${lib.escapeShellArg specialisation-marker} ]]; then
          current_theme="$(${cat} ${lib.escapeShellArg specialisation-marker})" || exit 1
          if [[ "$current_theme" == "${theme}" ]]; then
            exit 0
          fi
        fi

        specialisation_dir="$(${find-hm-generation})" || exit 1
        activation="$specialisation_dir/${theme}/activate"
        if [[ ! -x "$activation" ]]; then
          echo "Home Manager ${theme} specialisation activation not found: $activation" >&2
          exit 1
        fi
        "$activation"
        ${killall} -SIGUSR1 .hx-wrapped
        ${albert} restart
      '';
  in {
    enable = true;
    darkModeScripts = {
      activate = switch-theme-script "dark";
    };
    lightModeScripts = {
      activate = switch-theme-script "light";
    };
    settings = {
      lat = 48.86;
      lng = 2.35;
    };
  };

  # restart darkman after switching to new configuration
  systemd.user.services.darkman.Unit.X-SwitchMethod = "restart";

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.darkman];
    config.common."org.freedesktop.impl.portal.Settings" = "darkman";
  };
}
