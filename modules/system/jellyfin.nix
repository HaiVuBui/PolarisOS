{
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) jellyfinEnable;
in
{
  services.jellyfin = {
    enable = jellyfinEnable;
  };
}
