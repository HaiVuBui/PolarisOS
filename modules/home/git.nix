{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername gitEmail;
in
{
  programs.git = {
    enable = true;
    settings = {
      alias = {
        # br = "branch --sort=-committerdate";
        # co = "checkout";
        # df = "diff";
        # com = "commit -a";
        # gs = "stash";
        # gp = "pull";
        # lg = "log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %C(green)(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit";
        # st = "status";
      };
      credential.helper = "cache --timeout=7200";
      init.defaultBranch = "main"; # Set default new branches to 'main'
      log.date = "iso"; # ISO 8601 date format
      log.decorate = "full"; # Show branch/tag info in git log
      merge.conflictStyle = "diff3"; # Conflict resolution style for readable diffs
      push.default = "simple"; # Match modern push behavior
      user = {
        name = gitUsername;
        email = gitEmail;
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
    ];
  };
}
