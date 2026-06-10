{ config, ... }:
{
  services.jellyfin.enable = config.polaris.features.jellyfin;
}
