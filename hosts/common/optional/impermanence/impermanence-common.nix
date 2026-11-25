{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModule
    inputs.disko.nixosModules.default
  ];

  # always persist these
  environment.persistence."/persist/backup" = {
    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
      "/var/lib/systemd/rfkill"
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
