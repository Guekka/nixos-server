{config, ...}: {
  fileSystems."/samba" = {
    device = "//192.168.1.254/Disque dur";
    fsType = "cifs";
    options = [
      "vers=2.1"
      "iocharset=utf8"
      "user=samba_user"
      "credentials=${config.sops.secrets.samba_credentials.path}"
      "rw"
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
    ];
  };

  sops.secrets.samba_credentials.sopsFile = ../secrets.yaml;
}
