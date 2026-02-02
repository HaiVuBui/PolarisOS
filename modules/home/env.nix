{ pkgs, lib ? pkgs.lib, host, ... }:

let
  inherit (import ../../hosts/${host}/variables.nix) cudaEnable;

  basePackages = with pkgs; [
    # nix lsp
    nixd
    nixfmt-classic

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

    # Haskell
    ormolu
    haskell-language-server

    # Go
    gopls
    gofumpt

    # rust
    rustfmt
    rust-analyzer

    # latex
    texlab
    texliveFull
  ];

in {
  home.packages = basePackages
    ++ (lib.optionals cudaEnable (with pkgs; [ cudatoolkit ]));

  home.sessionVariables = { FLAKE = "${host}"; };
}
