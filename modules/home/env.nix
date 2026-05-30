{
  pkgs,
  lib ? pkgs.lib,
  host,
  ...
}:

let
  inherit (import ../../hosts/${host}/variables.nix) cudaEnable;

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
    python3
    basedpyright
    black
    (pkgs.buildFHSEnv {
      name = "pixi";
      runScript = "pixi";
      targetPkgs = pkgs: with pkgs; [ pixi ];
    })
    uv

    # Haskell
    ormolu
    haskell-language-server

    # Go
    gopls
    gofumpt

    # rust
    clippy
    rustfmt
    rust-analyzer

    # latex
    texlab
    texliveFull

    #marp
    marp-cli
  ];

in
{
  home.packages = basePackages ++ (lib.optionals cudaEnable (with pkgs; [ cudatoolkit ]));

  home.sessionVariables = {
    FLAKE = "${host}";
  };
}
