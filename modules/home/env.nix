{
  pkgs,
  lib ? pkgs.lib,
  host,
  osConfig,
  ...
}:

let
  basePackages = with pkgs; [
    # nix
    nixd
    nixfmt
    devenv

    # lua
    stylua

    # nvim
    tree-sitter

    # Java/JS
    nodejs
    yarn

    # Python
    basedpyright
    black
    (pkgs.buildFHSEnv {
      name = "pixi";
      runScript = "pixi";
      targetPkgs = pkgs: with pkgs; [ pixi ];
    })
    uv

    # Haskell
    # ormolu
    # haskell-language-server

    # Go
    # gopls
    # gofumpt

    # rust
    # clippy
    # rustfmt
    # rust-analyzer

    # latex
    # texlab
    # texliveFull
    # tex-fmt

    #marp
    # marp-cli
  ];

in
{
  home.packages =
    basePackages ++ (lib.optionals osConfig.polaris.features.cuda (with pkgs; [ cudatoolkit ]));

  home.sessionVariables = {
    FLAKE = "${host}";
  };
}
