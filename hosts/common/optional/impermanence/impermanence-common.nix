{
  config,
  inputs,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  diff-script = pkgs.writeShellScript "btrfs-diff-raw" (builtins.readFile ./btrfs-diff-script.sh);
in {
  imports = [
    inputs.impermanence.nixosModule
    inputs.disko.nixosModules.default
  ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "impermanence-diff" ''
      exec ${diff-script} "/dev/disk/by-label/${hostname}"
    '')
  ];

  # always persist these
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
