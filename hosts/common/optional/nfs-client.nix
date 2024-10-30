{
  fileSystems."/shared" = {
    device = "horus:/shared";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "x-systemd.requires=tailscaled.service"
      "x-systemd.before=tailscaled.service"
    ];
  };
}
