_: {
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # High compression, very fast.
    memoryPercent = 50; # Larger costs CPU time on compression under memory pressure.
  };

  # zram-tuned (CachyOS): swap to compressed RAM eagerly, no readahead
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };
}
