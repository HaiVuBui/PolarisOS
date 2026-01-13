{username, gpuProfile, host,...}:
{
  home.sessionVariables = {
    FLAKE = "${host}-${gpuProfile}";
  };
}

