{ osConfig, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "cache --timeout=7200";
      init.defaultBranch = "main"; # Set default new branches to 'main'
      log.date = "iso"; # ISO 8601 date format
      log.decorate = "full"; # Show branch/tag info in git log
      merge.conflictStyle = "diff3"; # Conflict resolution style for readable diffs
      push.default = "simple"; # Match modern push behavior
      user = {
        name = osConfig.polaris.git.username;
        email = osConfig.polaris.git.email;
      };
    };
    ignores = [
      ".direnv"
      ".envrc"
      "result" # Useful for Nix builds
      "*.swp" # Optional: vim swap files
      ".DS_Store" # Optional: macos junk
      ".pixi"
      "__pycache__"
      "typings"
      ".env"
      ".vscode"
      ".devenv"
      ".vexp"
    ];
  };
}
