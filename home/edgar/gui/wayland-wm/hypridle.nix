{
  config,
  inputs,
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
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  # screen idle
  services.hypridle = let
    hyprlock = lib.getExe config.programs.hyprlock.package;
  in {
    enable = true;
    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    lockCmd = hyprlock;

    listeners = [
      {
        timeout = 120;
        onTimeout = hyprlock;
      }
      {
        timeout = 300;
        onTimeout = suspendScript.outPath;
      }
    ];
  };
}
