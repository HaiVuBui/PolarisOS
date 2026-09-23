{ config, lib, pkgs, ... }:
lib.mkIf config.polaris.features.ollama {
  services.ollama = {
    enable = true;
    # ollama-cuda is built for sm_75+; the 1080 Ti is sm_61 and gets skipped,
    # silently falling back to CPU. Vulkan reaches Pascal without a source build.
    package = pkgs.ollama-vulkan;
    loadModels = [ config.polaris.logModel ];
    environmentVariables = {
      # Keeps the model loaded across the log job's chunked calls.
      OLLAMA_KEEP_ALIVE = "5m";
      # KV cache defaults to f16, four times the precision of the Q4 weights
      # it serves. q8_0 halves it at negligible cost.
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };

  # The model is file-backed page cache, which the kernel reclaims before it
  # swaps anything, so without this it evicts the model to keep a browser
  # resident. Protects what is loaded; does not force it in.
  # A cgroup is only protected up to its parent's memory.min, so the slice
  # needs it too or the setting on the service does nothing.
  systemd.services.ollama.serviceConfig.MemoryMin = "10G";
  systemd.slices.system.sliceConfig.MemoryMin = "10G";
}
