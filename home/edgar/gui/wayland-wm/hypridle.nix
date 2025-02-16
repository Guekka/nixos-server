{
  config,
  lib,
  pkgs,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  # screen idle
  services.hypridle = let
    hyprlock = lib.getExe config.programs.hyprlock.package;
    lock_cmd = "pidof hyprlock || ${hyprlock}";
  in {
    enable = true;
    settings = {
      general = {
        # after resume (instead of before sleep) seems to prevent hyprlock crashing
        after_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        inherit lock_cmd;
      };

      listener = [
        {
          timeout = 900;
          on-timeout = suspendScript.outPath;
        }
      ];
    };
  };
}
