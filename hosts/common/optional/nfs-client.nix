{
  fileSystems."/shared" = {
    device = "horus.bizel.fr:/shared";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "x-systemd.mount-timeout=3"
    ];
  };
}
