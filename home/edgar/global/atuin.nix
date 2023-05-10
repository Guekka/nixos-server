{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    flags = ["--disable-up-arrow"]; # I prefer fish up arrow
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      key_path = "/home/edgar/secrets/atuin_key";
      session_path = "/home/edgar/secrets/atuin_session";
      inline_height = 20;
    };
  };
}
