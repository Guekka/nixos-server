{config, ...}: {
  fileSystems."/samba" = {
    device = "//192.168.1.154/Disque dur";
    fsType = "cifs";
    options = [
      "vers=2.1"
      "iocharset=utf8"
      "credentials=${config.sops.secrets.samba_credentials.path}"
      "rw"
      "x-systemd.automount"
      "x-systemd.mount-timeout=12"
    ];
  };

  networking.wg-quick.interfaces.wg0_free.configFile = config.sops.secrets.wireguard-free-conf.path;

  sops.secrets = {
    samba_credentials.sopsFile = ../secrets.yaml;
    wireguard-free-conf.sopsFile = ../secrets.yaml;
  };
}
