{
  fileSystems."/shared" = {
    device = "horus:/shared";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
    ];
  };
}
