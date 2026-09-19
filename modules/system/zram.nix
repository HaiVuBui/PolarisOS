_: {
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # High compression, very fast.
    memoryPercent =
      100; # Use up to 100% of RAM size for the compressed block (don't worry, it doesn't reserve it upfront).
  };

  # zram-tuned (CachyOS): swap to compressed RAM eagerly, no readahead
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };
}
