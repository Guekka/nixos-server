{
  systemd = {
    mounts = [
      {
        type = "nfs4";
        what = "horus:/shared";
        where = "/shared";
      }
    ];
    automounts = [
      {
        where = "/shared";
        wantedBy = ["default.target"];
      }
    ];
  };
}
