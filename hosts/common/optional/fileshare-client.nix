{config, ...}: {
  fileSystems = let
    systemdMountOptions = [
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
    ];
  in {
    "/shared" = {
      device = "horus:/shared";
      fsType = "nfs4";
      options = systemdMountOptions;
    };

    "/samba" = {
      device = "//192.168.1.254/Disque dur";
      fsType = "cifs";
      options =
        [
          "vers=2.1"
          "iocharset=utf8"
          "user=samba_user"
          "credentials=${config.sops.secrets.samba_credentials.path}"
          "rw"
        ]
        ++ systemdMountOptions;
    };
  };

  sops.secrets.samba_credentials.sopsFile = ../secrets.yaml;
}
