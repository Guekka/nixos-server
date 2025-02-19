{
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
      for line in $(${home-manager} generations | ${grep} -o '/.*')
      do
        res=$(${find} $line | ${grep} specialisation | ${head} -1)
        output=$?
        if [[ $output -eq 0 ]] && [[ $res != "" ]]; then
            echo $res
            exit
        fi
      done
    '';

    switch-theme-script = theme: ''
      $(${find-hm-generation})/${theme}/activate
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
