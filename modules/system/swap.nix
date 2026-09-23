_: {
  # Two tiers. Anonymous pages go to compressed RAM first; only what zram
  # cannot hold, or cannot compress, falls through to the disk swapfile.
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # High compression, very fast.
    memoryPercent = 50; # Larger costs CPU time on compression under memory pressure.
    priority = 5;
  };

  # Lower priority than zram, so this is the backstop rather than the
  # first resort. Lives on its own NOCOW subvolume: btrfs refuses swapfiles
  # that are compressed or copy-on-write, and / is mounted compress=zstd:1.
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024;
      priority = 0;
    }
  ];

  # Global, so both tiers inherit these; tuned for zram, which is the tier
  # that actually gets used. Priority decides which device is written, not
  # these. page-cluster=0 disables readahead, right for zram and a mild
  # pessimisation for the swapfile — acceptable, since reaching disk at all
  # means zram is already full.
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };
}
