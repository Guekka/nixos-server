{
  systemd = {
    mounts = [
      {
        type = "nfs";
        what = "192.168.1.58:/shared";
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
