{ userConfig, pkgs, lib ? pkgs.lib, ... }:

let
  cDevLibs = with pkgs; [
    zlib
    openssl
    # cudatoolkit
  ];

  cDevTools = with pkgs; [
    llvmPackages_latest.clang
    llvmPackages_latest.libcxx
    llvmPackages_latest.lld
    llvmPackages_latest.lldb
    gcc
    gdb
    mold
    cmake
    ninja
    meson
    pkg-config
    ccache
    bear
    clang-tools
    cppcheck
    valgrind
    gnumake
  ];

  cRuntimeLibs = cDevLibs ++ (with pkgs; [
    stdenv.cc.cc
    llvmPackages_latest.libcxx
  ]);

  mkColonPath = paths: lib.concatStringsSep ":" (lib.filter (s: s != "") paths);

  includePath = lib.makeSearchPathOutput "dev" "include" cDevLibs;
  pkgConfigPath = lib.makeSearchPathOutput "dev" "lib/pkgconfig" cDevLibs;
  runtimeLibPath = lib.makeLibraryPath cRuntimeLibs;
in {
  environment.systemPackages =
    (with pkgs; [
      # nix lsp
      nixd
      nixfmt-classic

      #nvim
      tree-sitter

      # Java/JS
      nodejs

      #Python
      basedpyright
      python310
      pixi
      black

      # Haskell
      cabal-install
      ormolu
      haskell-language-server
      ghc
      stack

      #Nvim
      rsync

      # latex
      texlab
      texliveFull
      latexminted
    ])
    ++ cDevTools
    ++ cDevLibs;

  programs.ccache.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  environment.variables =
    let
      baseSessionVars = {
        XDG_PICTURES_DIR = "$HOME/randomShits/Pictures";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        OZONE_PLATFORM = "wayland";
      };

      cSessionVars = {
        PKG_CONFIG_PATH = mkColonPath [
          pkgConfigPath
          "$PKG_CONFIG_PATH"
        ];

        CPATH = mkColonPath [
          includePath
          "$CPATH"
        ];

        LIBRARY_PATH = mkColonPath [
          runtimeLibPath
          "$LIBRARY_PATH"
        ];

        LD_LIBRARY_PATH = mkColonPath [
          runtimeLibPath
          "/run/opengl-driver/lib"
          "$LD_LIBRARY_PATH"
        ];
      };
    in
    baseSessionVars // cSessionVars;
}

