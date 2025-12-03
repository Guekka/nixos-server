{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    acceleration = "rocm";
    environmentVariables = {
      # Divide context memory usage by 2
      # Could use q4 but more precision lost
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };

  services.open-webui.enable = true;

  environment.persistence."/persist/nobackup".directories = [
    {
      directory = "/var/lib/private/ollama";
      mode = "0700";
      defaultPerms.mode = "0700";
    }
    {
      directory = "/var/lib/private/open-webui";
      mode = "0700";
      defaultPerms.mode = "0700";
    }
  ];
}
