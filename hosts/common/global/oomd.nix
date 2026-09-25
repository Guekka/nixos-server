{
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    enableRootSlice = true;
    settings.OOM = {
      DefaultMemoryPressureDurationSec = "10s";
    };
  };
}
