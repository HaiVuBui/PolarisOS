{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    # or: inputs.zen-browser.homeModules.twilight
    # or: inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser.enable = true;

  # (optional) set policies, extensions, prefs
  programs.zen-browser.policies = {
    DisableTelemetry = true;
    DisableAppUpdate = true;
  };
  programs.zen-browser.profiles.default.extensions.packages =
    with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
      ublock-origin
  ];
}
