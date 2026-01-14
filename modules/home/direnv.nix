_: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # This enables the integration automatically
    config = {
      global = {
        # This specifically hides the "export +AR +AS..." wall of text
        hide_env_diff = true;

        # Optional: Reduces the "direnv: loading..." verbosity
        # valid options: "verbose", "plain", "json" (default is plain)
        # If you want TOTAL silence, keep your DIRENV_LOG_FORMAT variable approach,
        # but make sure to restart your terminal.
      };
    };
  };
}

