{
  systemd.oomd = {
    enable = true;
    enableUserServices = true;
    enableRootSlice = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "10s";
    };
  };
}
