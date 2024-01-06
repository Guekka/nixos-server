{
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    enableRootSlice = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "10s";
    };
  };
}
