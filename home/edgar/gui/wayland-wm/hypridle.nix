{
  config,
  lib,
  pkgs,
  ...
}: let
  waylandCommands = import ./commands.nix {inherit config lib pkgs;};

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
    lock_cmd = "pidof hyprlock || ${waylandCommands.lock}";
  in {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        inherit lock_cmd;
      };

      listener = [
        {
          timeout = 900;
          on-timeout =
            if waylandCommands.brightness.hasInternalPanel
            then suspendScript.outPath
            else lock_cmd;
          on-resume = lock_cmd;
        }
      ];
    };
  };
}
