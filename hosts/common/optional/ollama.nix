{
  lib,
  inputs,
  pkgs,
  ...
}: {
  disabledModules = ["services/misc/llama-cpp.nix"];
  imports = ["${inputs.nixpkgs-unstable}/nixos/modules/services/misc/llama-cpp.nix"];

  services.ollama = {
    enable = false;
    package = pkgs.unstable.ollama;
    acceleration = "rocm";
    environmentVariables = {
      # Divide context memory usage by 2
      # Could use q4 but more precision lost
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };

  # Mainly from <https://github.com/ErikFrankling/.dotfiles/blob/27a063c21dbc1a548e05752cddbf80fffb5d6810/modules/nixos/llama-cpp.nix>
  services.llama-cpp = {
    enable = true;

    # For Radeon
    package = pkgs.unstable.llama-cpp-vulkan;

    port = 9074;

    # ── Router Mode Configuration ────────────────────────────────────────
    # Single-model mode: set `model` to a path, leave modelsDir/modelsPreset null
    # Multi-model mode (router): set modelsDir and optionally modelsPreset
    model = null;

    # Directory containing all .gguf files - router serves all of them
    modelsDir = "/var/lib/llama-cpp/models";

    modelsPreset = {
      # Gemma 4 26B (adjust path and settings after downloading)
      "gemma4-26b" = {
        hf-repo = "unsloth/gemma-4-26B-A4B-it-GGUF";
        hf-file = "gemma-4-26B-A4B-it-UD-Q4_K_XL.gguf";
        alias = "gemma4-26b";
        n-gpu-layers = "999";
        jinja = "on";
      };
    };

    # ── Global Flags (Apply to All Models) ──────────────────────────────
    extraFlags = [
      # Router server: limit concurrent loaded models to save VRAM
      "--models-max"
      "1" # Load 1 model at a time, auto-swap on demand

      # Enable automatic model loading/unloading based on requests
      "--models-autoload"

      # ── GPU ───────────────────────────────────────────────────────────
      # Offload ALL transformer layers to GPU. Never touch CPU.
      # 999 = "more than any model will ever have" = all layers.
      "--n-gpu-layers"
      "999"

      # ── Context window ────────────────────────────────────────────────
      # 131072 = 128k tokens.
      "-c"
      "131072"

      # ── Idle model unload ─────────────────────────────────────────────
      # Unload model weights from GPU VRAM after 3h of no requests.
      "--sleep-idle-seconds"
      "1800" # 30 minutes

      # ── Performance ───────────────────────────────────────────────────
      # FA must be forced on (not auto) for quantized cache to work
      "--flash-attn"
      "on"
      "--cache-type-k"
      "q4_0"
      "--cache-type-v"
      "q8_0"

      # ── API ───────────────────────────────────────────────────────────
      "--jinja" # enable jinja2 chat template support

      # ── Prompt cache ──────────────────────────────────────────────────
      # Disabled: causes errors with this model but still consumes RAM
      "--cache-ram"
      "0"

      # ── Concurrency ───────────────────────────────────────────────────
      # Number of parallel request slots. 1 = sequential (safest for VRAM).
      "--parallel"
      "1"
    ];
  };

  # ── Vulkan-Specific Systemd Override ──────────────────────────────────
  # Required for AMD GPU access and shader compilation (W+X memory)
  systemd.services.llama-cpp = {
    environment = {
      GGML_VK_VISIBLE_DEVICES = "0"; # Select DGPU
      XDG_CACHE_HOME = "/var/lib/llama-cpp/.cache"; # Writable shader cache directory
      RADV_PERFTEST = "bfloat16,nogttspill"; # Vulkan performance optimizations
    };

    serviceConfig = {
      # Use static user instead of DynamicUser for stable directory ownership
      User = "llama-cpp";
      Group = "llama-cpp";
      SupplementaryGroups = [
        "video" # GPU device access
        "render" # DRM/render node access
      ];

      # Device access for Vulkan GPU
      DevicePolicy = lib.mkForce "closed";
      DeviceAllow = [
        "char-drm" # Direct Rendering Infrastructure (Vulkan)
      ];

      # Memory settings
      LimitMEMLOCK = "infinity"; # Allow mlock() for keeping model in RAM

      # OOM killer: sacrifice this service before user session
      OOMScoreAdjust = 900;

      # Restart policy on failure
      Restart = lib.mkForce "on-failure";

      # CRITICAL: Vulkan shader JIT compilation requires W+X memory mappings
      MemoryDenyWriteExecute = lib.mkForce false;

      # Allow /proc/meminfo access for memory accounting
      ProcSubset = lib.mkForce "all";
      ProtectProc = lib.mkForce "default";
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
    {
      directory = "/var/lib/private/llama-cpp";
      mode = "0700";
      defaultPerms.mode = "0700";
    }
    {
      directory = "/var/cache/llama-cpp";
      mode = "0700";
      defaultPerms.mode = "0700";
    }
  ];
}
